import { registerUnbound } from 'discourse-common/lib/helpers';
import { peopleImageUrl, peopleBannerUrl } from '../lib/site-utilities';

registerUnbound('people-image', function() {
  return new Handlebars.SafeString(`<img class='people-image' src='${peopleImageUrl}'/>`);
});

registerUnbound('people-banner', function() {
  return new Handlebars.SafeString(`<img class='people-banner' src='${peopleBannerUrl}'/>`);
})
