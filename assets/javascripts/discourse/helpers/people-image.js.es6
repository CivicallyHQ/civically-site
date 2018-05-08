import { registerUnbound } from 'discourse-common/lib/helpers';

const max = 43;

registerUnbound('people-image', function() {
  const num = Math.floor(Math.random() * (max - 1 + 1)) + 1;
  const html = `<img class='people-image' src='/plugins/civically-site/images/people/${num}.png'/>`;
  return new Handlebars.SafeString(html);
})
