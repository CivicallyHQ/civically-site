import { default as computed, on, observes } from 'ember-addons/ember-computed-decorators';
import { cookAsync } from 'discourse/lib/text';

export default Ember.Component.extend({
  router: Ember.inject.service('-routing'),
  currentRoute: Ember.computed.alias('router.router.currentRouteName'),
  classNames: 'missing-translations',
  showDescription: false,

  @on('init')
  setup() {
    const locale = this.get('locale');
    if (locale) {
      const rawHelp = I18n.t('civically.translate.help');

      cookAsync(rawHelp).then((cookedHelp) => {
        this.set('cookedHelp', cookedHelp);
      });
    }
  },

  @on('init')
  @observes('missing.[].length')
  setMissingCount() {
    const count = this.get('missing.[].length')
    const route = this.get('currentRoute');
    if (route.indexOf('loading') === -1) {
      Ember.run.scheduleOnce('afterRender', () => this.set('missingCount', count));
    }
  },

  didInsertElement() {
    Ember.$(document).on('click', Ember.run.bind(this, this.documentClick));
  },

  willDestroyElement() {
    Ember.$(document).off('click', Ember.run.bind(this, this.documentClick));
  },

  documentClick(e) {
    let $element = this.$('.description');
    let $target = $(e.target);
    if ($target.closest($element).length < 1 &&
        this._state !== 'destroying') {
      this.set('showDescription', false);
    }
  },

  @computed
  locales() {
    return JSON.parse(this.siteSettings.available_locales);
  },

  @computed('locales')
  locale(locales) {
    return locales.find(l => l.value === I18n.locale);
  },

  actions: {
    toggleDescription() {
      this.toggleProperty('showDescription');
    }
  }
});
