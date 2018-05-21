import { default as computed } from 'ember-addons/ember-computed-decorators';
import { buildWidgetList } from 'discourse/plugins/civically-app/discourse/lib/app-utilities';

export default Ember.Component.extend({
  @computed('currentUser.app_data')
  userWidgetList(appData) {
    return buildWidgetList(appData);
  },

  @computed('userWidgetList.[]', 'path')
  showPrompt(userWidgetList, path) {
    return path.indexOf('category') > -1 && userWidgetList.length < 3;
  },
})
