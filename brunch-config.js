exports.config = {
  files: {
    javascripts: {
      joinTo: "js/app.js"
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["web/static/css/app.css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: [
      /^(web\/static\/assets)/,
      /^(node_modules\/font-awesome)/
    ]
  },

  paths: {
    watched: [
      "web/static",
      "test/static",
      "node_modules/font-awesome/fonts/fontawesome-webfont.eot",
      "node_modules/font-awesome/fonts/fontawesome-webfont.svg",
      "node_modules/font-awesome/fonts/fontawesome-webfont.ttf",
      "node_modules/font-awesome/fonts/fontawesome-webfont.woff",
      "node_modules/font-awesome/fonts/fontawesome-webfont.woff2"
    ],
    public: "priv/static"
  },

  plugins: {
    babel: {
      presets: [
        [
          'env',
          {targets: {chrome: 52}, modules: 'commonjs', loose: true}
        ]
      ],
      ignore: [/(web\/static\/vendor)|node_modules/]
    },
    sass: {
      options: {
        includePaths: [
          "node_modules/bootstrap-sass/assets/stylesheets",
          "node_modules/font-awesome/scss",
          "node_modules/SmallPop"
        ]
      },
      precision: 8
    },
    copycat: {
      "fonts": ["node_modules/font-awesome/fonts"],
      verbose: true,
      onlyChanged: true
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": [
        "web/static/js/app"
      ]
    }
  },

  npm: {
    enabled: true
  }
};
