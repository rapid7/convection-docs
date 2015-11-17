var FS = require('fs');
var Path = require('path');

var Static = module.exports = function() {
  var root = Path.join.apply(Path, arguments);

  return (function(req, res, next) {
    // Protect against path traversal with ../
    var object = Path.resolve('/', req.path);
    object = Path.join(root, object);

    FS.stat(object, function(err, stats) {
      if (err && err.code == 'ENOENT') return res.status(404).end();
      if (err) return next(err);
      if (stats.isDirectory()) return next();

      res.set('content-length', stats.size);
      res.type(Path.extname(object));
      FS.createReadStream(object).pipe(res);
    });
  });
};
