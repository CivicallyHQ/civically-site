import { withPluginApi } from 'discourse/lib/plugin-api';
import { default as computed, on, observes } from 'ember-addons/ember-computed-decorators';
import { cookAsync } from 'discourse/lib/text';
import showModal from 'discourse/lib/show-modal';
import { staticRoutes } from '../lib/site-utilities';
import StaticPage from "discourse/models/static-page";
import { jumpToElement } from "discourse/lib/url";

export default {
  name: 'site-edits',
  initialize() {
    withPluginApi('0.8.12', api => {

      // TODO: figure out an elegant way of overriding the about route with the static route builder
      api.modifyClass('route:about', {
        renderTemplate() {
          this.render("static");
        },

        activate() {
          jumpToElement(document.location.hash.substr(1));
        },

        model() {
          return StaticPage.find('about');
        },

        setupController(controller, model) {
          this.controllerFor("static").set("model", model);
        },

        actions: {
          didTransition() {
            this.controllerFor("application").set("showFooter", true);
            return true;
          }
        }
      });

      api.modifyClass('controller:about', {
        @on('init')
        setDescription() {
          cookAsync(I18n.t('civically.about')).then(
            cooked => {
              this.set('description', cooked);
            }
          );
        }
      });

      api.modifyClass('controller:static', {
        @computed('model.path')
        showStaticImage(path) {
          return !this.site.mobileView && path !== 'login';
        }
      });

      const peopleImageRoutes = [
        {
          name: 'user',
          afterElement: '.user-table'
        },
        {
          name: 'group',
          afterElement: '.user-table .wrapper'
        },
        {
          name: 'invites.show',
          afterElement: '.two-col'
        }
      ];

      peopleImageRoutes.forEach((route) => {
        api.modifyClass(`route:${route.name}`, {
          renderTemplate() {
            this.render('people-wrapper');
          },

          setupController(controller, model) {
            let template = this.routeName;

            if (template.indexOf('.') > -1) {
              template = template.split('.').join('/');
            }

            controller.set('mainContent', template);

            Ember.run.scheduleOnce('afterRender', () => {
              $('.people-image').insertAfter(route.afterElement);
            });

            this._super(controller, model);
          }
        });
      });

      const footerRoutes = staticRoutes.map((r) => {
        let route = {
          name: r.name
        };

        if (['about', 'faq', 'tos', 'privacy'].indexOf(r.name) > -1) {
          route['contactType'] = 'default';
        }

        if (r.name === 'team') {
          route['contactType'] = 'team';
        }

        if (r.name === 'donate') {
          route['contactType'] = 'donate';
        }

        return route;
      });

      const generated = ['about', 'faq', 'tos', 'privacy'];

      footerRoutes.forEach((r) => {
        api.modifyClass(`route:${r.name}`, {
          generatedRoute() {
            return generated.indexOf(this.routeName) > -1;
          },

          renderTemplate() {
            let controller = this.generatedRoute() ? 'static-wrapper' : this.routeName;
            this.render('static-wrapper', { controller });
          },

          setupController(controller, model) {
            let contactType = r.contactType;
            let contactLabel = 'landing.contact.title';
            let showContact = true;
            let showDonate = true;

            if (r.name === 'donate' || !Discourse.SiteSettings.discourse_donations_enabled) {
              showDonate = false;
            }

            if (contactType === 'team') {
              contactLabel = 'landing.team.link';
            }

            if (contactType === 'donate') {
              contactLabel = 'landing.donate.link';
            }

            if (this.generatedRoute()) {
              this.controllerFor('static-wrapper').setProperties({
                mainContent: 'static',
                model,
                contactType,
                contactLabel,
                showContact,
                showDonate
              });
            } else {
              controller.setProperties({
                mainContent: this.routeName,
                contactType,
                contactLabel,
                showContact,
                showDonate
              });
            }

            this._super(controller, model);
          },

          actions: {
            contact(type) {
              let model = {};

              if (type !== 'default') {
                model['type'] = type;
              }

              showModal('landing-contact-modal', { model });
            }
          }
        });
      });
    });

    I18n.missing_translations = Ember.A();

    const existing = I18n.translate;

    I18n.translate = function(scope, options = {}) {
      if (scope && !options.skip_missing) {
        const exists = Boolean(this.lookup(scope, options));
        if (!exists && I18n.missing_translations.indexOf(scope) === -1 &&
            scope.indexOf('civically.translate') === -1) {
          I18n.missing_translations.pushObject(scope);
        }
      }
      return existing.apply(this, [scope, options]);
    };

    I18n.t = I18n.translate;

    withPluginApi('0.8.12', api => {
      api.modifyClass('controller:application', {

        @observes('currentPath')
        updateTranslations() {
          I18n.missing_translations.clear();
        },

        actions: {
          routeToHelp() {
            this.transitionToRoute('discovery.category', 'run', 'help').then(() => {
              Ember.run.scheduleOnce('afterRender', () => {
                $(".inline-composer input").focus();
              });
            });
          }
        }
      });
    });
  }
};
