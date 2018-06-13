import { default as computed } from 'ember-addons/ember-computed-decorators';
import { buildWidgetList } from 'discourse/plugins/civically-app/discourse/lib/app-utilities';

export default Ember.Component.extend({
  @computed('currentUser.app_data')
  userWidgetList(appData) {
    return buildWidgetList(appData);
  },

  @computed('currentUser.checklist.sets.getting_started')
  showPrompt(gettingStarted) {
    return gettingStarted && gettingStarted.complete;
  },
})
