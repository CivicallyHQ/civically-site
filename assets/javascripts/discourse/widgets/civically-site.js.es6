import { createAppWidget } from 'discourse/plugins/civically-app/discourse/widgets/app-widget';
import { createWidget } from 'discourse/widgets/widget';
import { iconNode } from 'discourse-common/lib/icon-library';
import DiscourseURL from 'discourse/lib/url';
import { h } from 'virtual-dom';
import { buildTitle, clearUnreadList } from 'discourse/plugins/civically-navigation/discourse/lib/utilities';

const typeUrl = function(type) {
  let filter = '';
  switch(type) {
    case 'petition':
      filter = 'c/petitions';
      break;
    case 'plan':
      filter = 'c/plans';
      break;
    case 'help':
      filter = 'c/help';
      break;
    case 'work':
      filter = 'c/work';
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

export default createAppWidget('civically-site', {
  defaultState() {
    return {
      currentType: 'petition',
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
    const type = this.state.currentType;
    if (items && items.length > 0) {
      return items.map((item) => this.attach('list-item', { item, type }));
    } else {
      return h('div.no-items', I18n.t('app.civically_site.list.none'));
    }
  },

  showList(currentType) {
    this.state.currentType = currentType;
    this.state.loading = true;
    this.scheduleRerender();
  },

  header() {
    return [
      h('div.app-title', I18n.t('app.civically_site.title'))
    ];
  },

  contents() {
    const state = this.state;
    const listScope = 'app.civically_site.list';
    let contents = [
      h('div.widget-multi-title', [
        buildTitle(this, listScope, 'petition'),
        buildTitle(this, listScope, 'plan'),
        buildTitle(this, listScope, 'work'),
        buildTitle(this, listScope, 'help')
      ])
    ];

    const loading = state.loading;
    let itemList = [];
    if (loading) {
      itemList = h('div.spinner.small');
      this.getItems(state.currentType);
    } else {
      clearUnreadList(this, state.currentType);
      itemList = h('ul', this.itemList());
    };

    const moreLink = typeUrl(state.currentType);
    contents.push([
      h('div.widget-list', [
        itemList,
        h('div.widget-list-controls', this.attach('link', {
          className: 'p-link',
          href: `/${moreLink}`,
          label: 'app.civically_site.list.more'
        }))
      ])
    ]);

    return contents;
  }
});
