import { withPluginApi } from 'discourse/lib/plugin-api';
import { default as computed, on, observes } from 'ember-addons/ember-computed-decorators';
import { cookAsync } from 'discourse/lib/text';
import showModal from 'discourse/lib/show-modal';

export default {
  name: 'site-edits',
  initialize() {
    withPluginApi('0.8.12', api => {
      api.modifyClass('controller:about', {
        @on('init')
        setDescription() {
          cookAsync(I18n.t('civically.about')).then(
            cooked => {
              this.set('description', cooked);
            }
          );
        },

        actions: {
          contact() {
            showModal('landing-contact-modal');
          }
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
        }
      ];

      peopleImageRoutes.forEach((route) => {
        api.modifyClass(`route:${route.name}`, {
          renderTemplate() {
            this.render('people-wrapper');
          },

          setupController(controller, model) {
            controller.set('mainContent', this.routeName);

            Ember.run.scheduleOnce('afterRender', () => {
              $('.people-image').insertAfter(route.afterElement);
            });

            this._super(controller, model);
          }
        });
      })
    });

    I18n.missing_translations = Ember.A();

    const existing = I18n.translate;

    I18n.translate = function(scope, options = {}) {
      if (!options.skip_missing) {
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
        @on('init')
        setupTranslations() {
          this.positionTranslations();
          $(window).on('resize', Ember.run.bind(this, this.positionTranslations));
        },

        @observes('currentPath')
        updateTranslations() {
          I18n.missing_translations.clear();
          this.positionTranslations();
        },

        positionTranslations() {
          if (!this.site.mobileView) {
            Ember.run.scheduleOnce('afterRender', () => {
              const $translations = $('.missing-translations-container');
              const $outlet = $('#main-outlet');
              const offset = ($(window).width() - ($outlet.offset().left + $outlet.outerWidth()))
              $translations.css('right', offset);
            });
          }
        },

        actions: {
          routeToHelp() {
            this.transitionToRoute('discovery.category', 'run', 'help').then(() => {
              Ember.run.scheduleOnce('afterRender', () => {
                $(".inline-composer input").focus();
              })
            })
          }
        }
      });
    });
  }
};
