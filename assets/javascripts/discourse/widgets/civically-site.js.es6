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

export default createWidget('civically-site', {
  tagName: 'div.civically-site.widget-container',
  buildKey: () => 'civically-site',

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
      return h('div.no-items', I18n.t('civically.list.none'));
    }
  },

  buildTitle(type) {
    const currentType = this.state.currentType;
    const active = currentType === type;

    let classes = 'list-title';
    if (active) classes += ' active';

    return this.attach('link', {
      action: 'showList',
      actionParam: type,
      title: `civically.list.${type}.help`,
      label: `civically.list.${type}.title`,
      className: classes
    });
  },

  showList(currentType) {
    this.state.currentType = currentType;
    this.state.loading = true;
    this.scheduleRerender();
  },

  html(attrs, state) {
    const loading = state.loading;

    let contents = [
      h('div.widget-label', I18n.t('civically.title')),
      h('div.widget-multi-title', [
        this.buildTitle('petition'),
        this.buildTitle('plan'),
        this.buildTitle('work'),
        this.buildTitle('help')
      ])
    ];

    contents.push();

    let itemList = [];
    if (loading) {
      itemList = h('div.spinner.small');
      this.getItems(state.currentType);
    } else {
      itemList = h('ul', this.itemList());
    };

    const moreLink = typeUrl(state.currentType);
    contents.push([
      h('div.widget-list', [
        itemList,
        h('div.widget-list-controls', this.attach('link', {
          className: 'p-link no-underline',
          href: `/${moreLink}`,
          label: 'civically.list.more'
        }))
      ])
    ]);

    return contents;
  }
});
