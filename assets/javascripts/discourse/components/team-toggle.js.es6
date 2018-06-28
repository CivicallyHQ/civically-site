import { ajax } from 'discourse/lib/ajax';
import { popupAjaxError } from 'discourse/lib/ajax-error';
import { default as computed } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  @computed('model.team_member')
  label(isMember) {
    return isMember ? 'team.remove' : 'team.add';
  },

  @computed('model.team_member')
  icon(isMember) {
    return isMember ? 'times' : 'plus';
  },

  toggleMembership() {
    this.set('toggling', true);
    ajax('/team/toggle-membership', {
      data: {
        user_id: this.get('model.id')
      },
      type: "PUT"
    }).then((result) => {
      this.set('model.team_member', result.state);
    }).catch(popupAjaxError)
      .finally(() => this.set('toggling', false));
  },

  actions: {
    toggleMembership() {
      this.toggleMembership();
    }
  }
});
