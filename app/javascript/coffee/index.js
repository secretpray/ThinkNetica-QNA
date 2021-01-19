function importAll (r) {
  r.keys().forEach(r);
}
importAll(require.context('coffee', true, /\.coffee$/));
