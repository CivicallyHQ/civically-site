import { default as computed } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  classNames: 'static-image',

  @computed('name')
  imageUrl(name) {
    return `/plugins/civically-site/images/${name}.png`;
  }
});
