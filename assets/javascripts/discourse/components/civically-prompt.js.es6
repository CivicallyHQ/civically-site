import { default as computed } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  @computed('currentUser.app_data')
  userWidgetList(appData) {
    const appUtilities = 'discourse/plugins/civically-app/discourse/lib/app-utilities';
    if (requirejs.entries[appUtilities]) {
      const buildWidgetList = requirejs(appUtilities);
      return buildWidgetList(appData);
    } else {
      return [];
    }
  },

  @computed('currentUser.checklist.sets.getting_started')
  showPrompt(gettingStarted) {
    return gettingStarted && gettingStarted.complete;
  },
});
