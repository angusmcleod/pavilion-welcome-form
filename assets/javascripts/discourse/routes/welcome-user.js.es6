import UserForm from 'discourse/plugins/discourse-user-form/discourse/models/user-form';
import UserFormRoute from 'discourse/plugins/discourse-user-form/discourse/mixins/user-form-route';

export default Ember.Route.extend(UserFormRoute, {
  model() {
    if (!this.get('currentUser')) return {};
    return Ember.RSVP.hash({
      setup: UserForm.get('welcome_user')
    })
  },

  setupController(controller, model) {
    let setup = model.setup || {};
    let step = Number(setup['currentStep']) || 0;
    setup['currentStep'] = setup['activeStep'] = step;
    controller.set('setup', setup);
  }
})
