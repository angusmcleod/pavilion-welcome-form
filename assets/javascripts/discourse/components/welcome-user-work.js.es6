export default Ember.Component.extend({
  didInsertElement() {
    this.sendAction('updateValidation', '');
  }
})
