import { withPluginApi } from 'discourse/lib/plugin-api';
import { on } from 'ember-addons/ember-computed-decorators';
import { cookAsync } from 'discourse/lib/text';
import showModal from 'discourse/lib/show-modal';

export default {
  name: 'site-edits',
  initialize() {
    withPluginApi('0.8.12', api => {
      api.modifyClass('controller:about', {
        @on('init')
        setDescription() {
          cookAsync(I18n.t('civically.about')).then(
            cooked => {
              this.set('description', cooked);
            }
          );
        },

        actions: {
          contact() {
            showModal('landing-contact-modal');
          }
        }
      });
    });
  }
};
