export default Ember.Component.extend({
  classNames: 'coming-soon',

  mouseEnter() {
    this.set('show', true);
  },

  mouseLeave() {
    this.set('show', false);
  }
});
