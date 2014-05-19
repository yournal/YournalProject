(function(window, document) {
  var meanstack, modules;
  modules = {};
  meanstack = {};
  meanstack.modules = [];
  if (window.meanstack != null) {
    meanstack.name = window.meanstack.replace(/[.-_]/g, '.');
  }
  meanstack.module = function(name, type, dependencies) {
    if (name in modules) {
      return modules[name];
    }
    if (type == null) {
      dependencies = [];
      type = 'project';
    } else if (typeof type === 'object') {
      dependencies = type;
      type = 'project';
    }
    meanstack.modules.push(name);
    modules[name] = angular.module(name, dependencies);
    modules[name].mean = {};
    modules[name].mean.name = name;
    if (type === 'project') {
      modules[name].mean.module = function(str) {
        return "" + modules[name].name + "." + str;
      };
      modules[name].mean.asset = function(str) {
        return "public/" + str;
      };
      modules[name].mean.resource = function(str) {
        return "public/js/" + str;
      };
    } else if (type === 'plugin') {
      modules[name].mean.module = function(str) {
        return "" + modules[name].name + "." + str;
      };
      modules[name].mean.asset = function(str) {
        return "public/plugins/" + modules[name].mean.name + "/" + str;
      };
      modules[name].mean.resource = function(str) {
        return "public/plugins/" + modules[name].mean.name + "/js/" + str;
      };
    }
    meanstack[name] = modules[name].mean;
    return modules[name];
  };
  meanstack.init = function(app) {
    angular.element(document).ready(function() {
      var $http, injector;
      if (meanstack.ready != null) {
        meanstack.ready(app);
      }
      injector = angular.injector(['ng']);
      $http = injector.get('$http');
      return $http.get('/mean.json').then(function(response) {
        var name, nodename, _i, _len, _ref;
        if (meanstack.name == null) {
          meanstack.name = response.data.name;
        }
        meanstack.mount = response.data.mount;
        meanstack.assets = response.data.assets;
        _ref = meanstack.modules;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          name = _ref[_i];
          nodename = name.replace(/[.-_]/g, '-');
          if (meanstack.assets[nodename] != null) {
            meanstack[name].assets = meanstack.assets[nodename];
          }
        }
        app.constant('$mean', meanstack);
        if (meanstack.boostrap == null) {
          return angular.bootstrap(document, [app.name]);
        } else {
          return meanstack.boostrap(app);
        }
      });
    });
  };
  return window.meanstack = meanstack;
})(window, document);

//# sourceMappingURL=angular-meanstack.js.map
