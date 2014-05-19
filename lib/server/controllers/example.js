module.exports = function($views) {
  return {
    home: function(req, res) {
      return $views.index.render(req, res);
    }
  };
};
