import { createWidget } from 'discourse/widgets/widget';
import { iconNode } from 'discourse-common/lib/icon-library';
import DiscourseURL from 'discourse/lib/url';
import { h } from 'virtual-dom';

const typeUrl = function(type) {
  let filter = '';
  switch(type) {
    case 'petition':
      filter = 'c/petitions';
      break;
    case 'plan':
      filter = 'c/plans';
      break;
    case 'work':
      filter = 'c/work';
      break;
    case 'run':
      filter = 'c/run';
      break;
  };
  return filter;
};

const rightContent = function(type, item) {
  if ((type === 'petition' || type === 'plan') && item.vote_count) {
    return h('div', [
      h('span', [item.vote_count]),
      iconNode('check-square-o')
    ]);
  }
};

createWidget('list-item', {
  tagName: 'li.list-item',

  html(attrs) {
    const type = attrs.type;
    const item = attrs.item;
    return [
      h('span.title', item.title),
      h('div.right', rightContent(type, item))
    ];
  },

  click() {
    const slug = this.attrs.item.slug;
    DiscourseURL.routeTo(`/t/${slug}`);
  }
});

// Site Widget
const navigationUtilitiesPath = 'discourse/plugins/civically-navigation/discourse/lib/utilities';
const appWidgetPath = 'discourse/plugins/civically-app/discourse/widgets/app-widget';
let siteWidget = {};

if (requirejs.entries[navigationUtilitiesPath] && requirejs.entries[appWidgetPath]) {
  const buildTitle = requirejs(navigationUtilitiesPath).buildTitle;
  const clearUnreadList = requirejs(navigationUtilitiesPath).clearUnreadList;
  const createAppWidget = requirejs(appWidgetPath).createAppWidget;

  const siteWidgetParams = {
    defaultState() {
      return {
        currentListType: 'petition',
        loading: true
      };
    },

    getItems(type) {
      const filter = typeUrl(type);
      let params = {};

      if (type !== 'popular') {
        params['no_definitions'] = true;
      }

      this.store.findFiltered('topicList', { filter, params }).then((list) => {
        this.state.items = list.topics.slice(0,5);
        this.state.loading = false;
        this.scheduleRerender();
      });
    },

    itemList() {
      const items = this.state.items;
      const type = this.state.currentListType;
      if (items && items.length > 0) {
        return items.map((item) => this.attach('list-item', { item, type }));
      } else {
        return h('div.no-items', I18n.t('app.civically_site.list.none'));
      }
    },

    showList(currentListType) {
      this.state.currentListType = currentListType;
      this.state.loading = true;
      this.scheduleRerender();
    },

    contents() {
      const listScope = 'app.civically_site.list';
      const currentListType = this.state.currentListType;

      let contents = [
        h('div.widget-multi-title', [
          buildTitle(this, listScope, 'petition'),
          buildTitle(this, listScope, 'plan'),
          buildTitle(this, listScope, 'work'),
          buildTitle(this, listScope, 'run')
        ])
      ];

      const loading = this.state.loading;
      let itemList = [currentListType];

      if (loading) {
        itemList = h('div.spinner.small');
        this.getItems(currentListType);
      } else {
        clearUnreadList(this, currentListType);
        itemList = h('ul', this.itemList());
      };

      const moreLink = typeUrl(currentListType);

      contents.push(h('div.widget-list', [
        itemList,
        h('div.widget-list-controls', this.attach('link', {
          className: 'p-link',
          href: `/${moreLink}`,
          label: 'more'
        }))
      ]));

      return contents;
    }
  };

  siteWidget = createAppWidget('civically-site', siteWidgetParams);
}

export default siteWidget;
