import { getOwner } from 'discourse-common/lib/get-owner';

export default {
  actions: {
    routeToHelp() {
      const application = getOwner(this).lookup('controller:application');
      application.send('routeToHelp')
    }
  }
}
