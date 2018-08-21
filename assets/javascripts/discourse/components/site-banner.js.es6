import { default as computed } from 'ember-addons/ember-computed-decorators';
import { peopleBannerUrl } from 'discourse/plugins/civically-site/discourse/lib/site-utilities';

export default Ember.Component.extend({
  showCta: false,
  classNameBindings: ['bannerStyle', ':site-banner', 'showCta'],
  attributeBindings: ['bannerStyle:style'],

  @computed('showCta')
  bannerStyle(showCta) {
    const mobileView = this.get('site.mobileView');
    let style = '';

    if (!mobileView || showCta) {
      let url;

      if (showCta) {
        url = '/plugins/civically-private/images/people_background.png';
      } else {
        url = peopleBannerUrl();
      }

      style += `background-image: url('${url}');`;
    }
    return new Handlebars.SafeString(style);
  },
});
