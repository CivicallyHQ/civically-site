import { getOwner } from 'discourse-common/lib/get-owner';

export default {
  setupComponent(attrs, component) {
    const controller = getOwner(this).lookup('controller:static');
    component.set('controller', controller);
  }
};
