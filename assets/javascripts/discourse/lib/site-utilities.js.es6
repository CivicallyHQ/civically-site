let staticRoutes = [
  {
    name: 'about',
    label: 'about.simple_title'
  },
  {
    name: 'team',
    label: 'team.label',
  },
  {
    name: 'faq',
    label: 'faq'
  },
  {
    name: 'tos',
    label: 'terms_of_service'
  },
  {
    name: 'privacy',
    label: 'privacy'
  }
];

if (Discourse.SiteSettings.discourse_donations_enabled) {
  staticRoutes.splice(2, 0, {
    name: 'donate',
    label: 'discourse_donations.nav_item'
  });
}

const maxImage = 43;
const maxBanner = 5;
const baseUrl = '/plugins/civically-private/images';

function random(max) {
  return Math.floor(Math.random() * (max - 1 + 1)) + 1;
}

const peopleImageUrl = function() {
  return baseUrl + `/people/${random(maxImage)}.png`;
}

const peopleBannerUrl = function() {
  return baseUrl + `/people_banners/${random(maxBanner)}.png`;
}

export { staticRoutes, peopleImageUrl, peopleBannerUrl };
