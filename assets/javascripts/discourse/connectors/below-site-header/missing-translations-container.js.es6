export default {
  setupComponent(attrs, component) {
    I18n.missing_translations.addObserver('[]', () => {
      const missing = I18n.missing_translations;
      const hasMissing = missing.length > 0;
      Ember.run.once(this, () => {
        component.setProperties({
          hasMissing,
          missing
        });
      });
    });
  }
};
