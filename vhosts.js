module.exports = function($app, $ext) {
  return [
    {
      callback: function(req, res, next) {
        return $app(req, res, next);
      },
      hostnames: [],
      paths: [],
      protocols: [],
      ports: [],
      methods: []
    }
  ];
};
