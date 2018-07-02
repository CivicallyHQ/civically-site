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

export { staticRoutes };
