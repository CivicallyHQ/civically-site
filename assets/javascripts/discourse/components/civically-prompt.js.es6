import { default as computed } from 'ember-addons/ember-computed-decorators';
import { buildWidgetList } from 'discourse/plugins/civically-app/discourse/lib/app-utilities';

export default Ember.Component.extend({
  @computed('currentUser.app_data')
  userWidgetList(appData) {
    return buildWidgetList(appData);
  },

  @computed('userWidgetList.[]', 'currentUser.place_category_id', 'currentUser.checklist_sets.getting_started')
  showPrompt(userWidgetList, hasPlace, gettingStartedChecklist) {
    return hasPlace && userWidgetList.length < 3 && gettingStartedChecklist && gettingStartedChecklist.complete;
  },
})
