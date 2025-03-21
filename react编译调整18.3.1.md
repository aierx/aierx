### package.json

```json

{
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "devDependencies": {
    "@babel/cli": "^7.10.5",
    "@babel/code-frame": "^7.10.4",
    "@babel/core": "^7.11.1",
    "@babel/eslint-parser": "^7.11.4",
    "@babel/helper-module-imports": "^7.10.4",
    "@babel/parser": "^7.11.3",
    "@babel/plugin-external-helpers": "^7.10.4",
    "@babel/plugin-proposal-class-properties": "^7.10.4",
    "@babel/plugin-proposal-object-rest-spread": "^7.11.0",
    "@babel/plugin-syntax-dynamic-import": "^7.8.3",
    "@babel/plugin-syntax-import-meta": "^7.10.4",
    "@babel/plugin-syntax-jsx": "^7.10.4",
    "@babel/plugin-syntax-typescript": "^7.14.5",
    "@babel/plugin-transform-arrow-functions": "^7.10.4",
    "@babel/plugin-transform-async-to-generator": "^7.10.4",
    "@babel/plugin-transform-block-scoped-functions": "^7.10.4",
    "@babel/plugin-transform-block-scoping": "^7.11.1",
    "@babel/plugin-transform-classes": "^7.10.4",
    "@babel/plugin-transform-computed-properties": "^7.10.4",
    "@babel/plugin-transform-destructuring": "^7.10.4",
    "@babel/plugin-transform-for-of": "^7.10.4",
    "@babel/plugin-transform-literals": "^7.10.4",
    "@babel/plugin-transform-modules-commonjs": "^7.10.4",
    "@babel/plugin-transform-object-super": "^7.10.4",
    "@babel/plugin-transform-parameters": "^7.10.5",
    "@babel/plugin-transform-react-jsx-source": "^7.10.5",
    "@babel/plugin-transform-shorthand-properties": "^7.10.4",
    "@babel/plugin-transform-spread": "^7.11.0",
    "@babel/plugin-transform-template-literals": "^7.10.5",
    "@babel/preset-flow": "^7.10.4",
    "@babel/preset-react": "^7.10.4",
    "@babel/traverse": "^7.11.0",
    "abort-controller": "^3.0.0",
    "art": "0.10.1",
    "babel-eslint": "^10.0.3",
    "babel-plugin-syntax-trailing-function-commas": "^6.5.0",
    "chalk": "^3.0.0",
    "cli-table": "^0.3.1",
    "coffee-script": "^1.12.7",
    "confusing-browser-globals": "^1.0.9",
    "core-js": "^3.6.4",
    "coveralls": "^3.0.9",
    "create-react-class": "^15.6.3",
    "danger": "^9.2.10",
    "error-stack-parser": "^2.0.6",
    "eslint": "^7.7.0",
    "eslint-config-fbjs": "^3.1.1",
    "eslint-config-prettier": "^6.9.0",
    "eslint-plugin-babel": "^5.3.0",
    "eslint-plugin-eslint-plugin": "^3.5.3",
    "eslint-plugin-flowtype": "^2.25.0",
    "eslint-plugin-jest": "^22.15.0",
    "eslint-plugin-jsx-a11y": "^6.3.1",
    "eslint-plugin-no-for-of-loops": "^1.0.0",
    "eslint-plugin-no-function-declare-after-return": "^1.0.0",
    "eslint-plugin-react": "^6.7.1",
    "eslint-plugin-react-internal": "link:./scripts/eslint-rules",
    "fbjs-scripts": "1.2.0",
    "filesize": "^6.0.1",
    "flow-bin": "0.97",
    "glob": "^7.1.6",
    "glob-stream": "^6.1.0",
    "google-closure-compiler": "^20200517.0.0",
    "gzip-size": "^5.1.1",
    "jasmine-check": "^1.0.0-rc.0",
    "jest": "^26.6.3",
    "jest-cli": "^26.6.3",
    "jest-diff": "^26.6.2",
    "jest-snapshot-serializer-raw": "^1.1.0",
    "minimatch": "^3.0.4",
    "minimist": "^1.2.3",
    "mkdirp": "^0.5.1",
    "ncp": "^2.0.0",
    "pacote": "^10.3.0",
    "prettier": "1.19.1",
    "prop-types": "^15.6.2",
    "random-seed": "^0.3.0",
    "react-lifecycles-compat": "^3.0.4",
    "rimraf": "^3.0.0",
    "rollup": "^1.19.4",
    "rollup-plugin-babel": "^4.0.1",
    "rollup-plugin-commonjs": "^9.3.4",
    "rollup-plugin-node-resolve": "^2.1.1",
    "rollup-plugin-prettier": "^0.6.0",
    "rollup-plugin-replace": "^2.2.0",
    "rollup-plugin-strip-banner": "^0.2.0",
    "semver": "^7.1.1",
    "targz": "^1.0.1",
    "through2": "^3.0.1",
    "tmp": "^0.1.0",
    "typescript": "^3.7.5",
    "web-streams-polyfill": "^3.1.1",
    "webpack": "^4.41.2",
    "yargs": "^15.3.1"
  },
  "devEngines": {
    "node": "^12.17.0 || 13.x || 14.x || 15.x || 16.x || 17.x"
  },
  "jest": {
    "testRegex": "/scripts/jest/dont-run-jest-directly\\.js$"
  },
  "scripts": {
    "build": "node ./scripts/rollup/build.js --type=NODE_DEV",
    "build-combined": "node ./scripts/rollup/build-all-release-channels.js",
    "build-for-devtools": "cross-env RELEASE_CHANNEL=experimental yarn build react/index,react/jsx,react-dom/index,react-dom/unstable_testing,react-is,react-debug-tools,scheduler,react-test-renderer,react-refresh,react-art --type=NODE && cp -r ./build/node_modules build/oss-experimental/",
    "build-for-devtools-dev": "yarn build-for-devtools --type=NODE_DEV",
    "build-for-devtools-prod": "yarn build-for-devtools --type=NODE_PROD",
    "linc": "node ./scripts/tasks/linc.js",
    "lint": "node ./scripts/tasks/eslint.js",
    "lint-build": "node ./scripts/rollup/validate/index.js",
    "extract-errors": "node scripts/error-codes/extract-errors.js",
    "postinstall": "node node_modules/fbjs-scripts/node/check-dev-engines.js package.json && node ./scripts/flow/createFlowConfigs.js && node ./scripts/yarn/downloadReactIsForPrettyFormat.js",
    "debug-test": "yarn test --deprecated 'yarn test --debug'",
    "test": "node ./scripts/jest/jest-cli.js",
    "test-stable": "node ./scripts/jest/jest-cli.js --release-channel=stable",
    "test-www": "node ./scripts/jest/jest-cli.js --release-channel=www-modern",
    "test-classic": "node ./scripts/jest/jest-cli.js --release-channel=www-classic",
    "test-www-variant": "yarn test --deprecated 'yarn test-www --variant'",
    "test-prod-www": "yarn test --deprecated 'yarn test-www --prod'",
    "test-prod-www-variant": "yarn test --deprecated 'yarn test-www --prod --variant'",
    "test-persistent": "yarn test --deprecated 'yarn test --persistent'",
    "debug-test-persistent": "yarn test --deprecated 'yarn test --debug --persistent'",
    "test-prod": "yarn test --deprecated 'yarn test --prod'",
    "debug-test-prod": "yarn test --deprecated 'yarn test --debug --prod'",
    "test-prod-build": "yarn test --deprecated 'yarn test --prod --build'",
    "test-build": "yarn test --deprecated 'yarn test --build'",
    "test-build-prod": "yarn test --deprecated 'yarn test --build --prod'",
    "test-build-devtools": "node ./scripts/jest/jest-cli.js --build --project devtools --release-channel=experimental",
    "debug-test-build-devtools": "yarn test --deprecated 'yarn test-build-devtools --debug'",
    "test-dom-fixture": "cd fixtures/dom && yarn && yarn prestart && yarn test",
    "flow": "node ./scripts/tasks/flow.js",
    "flow-ci": "node ./scripts/tasks/flow-ci.js",
    "prettier": "node ./scripts/prettier/index.js write-changed",
    "prettier-all": "node ./scripts/prettier/index.js write",
    "version-check": "node ./scripts/tasks/version-check.js",
    "merge-fork": "node ./scripts/merge-fork/merge-fork.js",
    "replace-fork": "node ./scripts/merge-fork/replace-fork.js",
    "publish-prereleases": "node ./scripts/release/publish-using-ci-workflow.js",
    "download-build": "node ./scripts/release/download-experimental-build.js",
    "download-build-for-head": "node ./scripts/release/download-experimental-build.js --commit=$(git rev-parse HEAD)",
    "download-build-in-codesandbox-ci": "cd scripts/release && yarn install && cd ../../ && yarn download-build-for-head || yarn build-combined --type=node react/index react-dom/index react-dom/src/server react-dom/test-utils scheduler/index react/jsx-runtime react/jsx-dev-runtime",
    "check-release-dependencies": "node ./scripts/release/check-release-dependencies"
  },
  "resolutions": {
    "react-is": "npm:react-is"
  }
}


```


### scripts/rollup/builds.js

```java

'use strict';

const rollup = require('rollup');
const babel = require('rollup-plugin-babel');
const closure = require('./plugins/closure-plugin');
const commonjs = require('rollup-plugin-commonjs');
const prettier = require('rollup-plugin-prettier');
const replace = require('rollup-plugin-replace');
const stripBanner = require('rollup-plugin-strip-banner');
const chalk = require('chalk');
const resolve = require('rollup-plugin-node-resolve');
const fs = require('fs');
const argv = require('minimist')(process.argv.slice(2));
const Modules = require('./modules');
const Bundles = require('./bundles');
const Stats = require('./stats');
const Sync = require('./sync');
const sizes = require('./plugins/sizes-plugin');
const useForks = require('./plugins/use-forks-plugin');
const stripUnusedImports = require('./plugins/strip-unused-imports');
const Packaging = require('./packaging');
const {asyncRimRaf} = require('./utils');
const codeFrame = require('babel-code-frame');
const Wrappers = require('./wrappers');

const RELEASE_CHANNEL = process.env.RELEASE_CHANNEL;

// Default to building in experimental mode. If the release channel is set via
// an environment variable, then check if it's "experimental".
const __EXPERIMENTAL__ =
  typeof RELEASE_CHANNEL === 'string'
    ? RELEASE_CHANNEL === 'experimental'
    : true;

// Errors in promises should be fatal.
let loggedErrors = new Set();
process.on('unhandledRejection', err => {
  if (loggedErrors.has(err)) {
    // No need to print it twice.
    process.exit(1);
  }
  throw err;
});

const {
  NODE_ES2015,
  NODE_ESM,
  UMD_DEV,
  UMD_PROD,
  UMD_PROFILING,
  NODE_DEV,
  NODE_PROD,
  NODE_PROFILING,
  FB_WWW_DEV,
  FB_WWW_PROD,
  FB_WWW_PROFILING,
  RN_OSS_DEV,
  RN_OSS_PROD,
  RN_OSS_PROFILING,
  RN_FB_DEV,
  RN_FB_PROD,
  RN_FB_PROFILING,
} = Bundles.bundleTypes;

const {getFilename} = Bundles;

function parseRequestedNames(names, toCase) {
  let result = [];
  for (let i = 0; i < names.length; i++) {
    let splitNames = names[i].split(',');
    for (let j = 0; j < splitNames.length; j++) {
      let name = splitNames[j].trim();
      if (!name) {
        continue;
      }
      if (toCase === 'uppercase') {
        name = name.toUpperCase();
      } else if (toCase === 'lowercase') {
        name = name.toLowerCase();
      }
      result.push(name);
    }
  }
  return result;
}

const requestedBundleTypes = argv.type
  ? parseRequestedNames([argv.type], 'uppercase')
  : [];
const requestedBundleNames = parseRequestedNames(argv._, 'lowercase');
const forcePrettyOutput = argv.pretty;
const isWatchMode = argv.watch;
const syncFBSourcePath = argv['sync-fbsource'];
const syncWWWPath = argv['sync-www'];

const closureOptions = {
  compilation_level: 'SIMPLE',
  language_in: 'ECMASCRIPT_2015',
  language_out: 'ECMASCRIPT5_STRICT',
  env: 'CUSTOM',
  warning_level: 'QUIET',
  apply_input_source_maps: false,
  use_types_for_optimization: false,
  process_common_js_modules: false,
  rewrite_polyfills: false,
  inject_libraries: false,
};

// Non-ES2015 stuff applied before closure compiler.
const babelPlugins = [
  // These plugins filter out non-ES2015.
  '@babel/plugin-transform-flow-strip-types',
  ['@babel/plugin-proposal-class-properties', {loose: true}],
  'syntax-trailing-function-commas',
  // These use loose mode which avoids embedding a runtime.
  // TODO: Remove object spread from the source. Prefer Object.assign instead.
  [
    '@babel/plugin-proposal-object-rest-spread',
    {loose: true, useBuiltIns: true},
  ],
  ['@babel/plugin-transform-template-literals', {loose: true}],
  // TODO: Remove for...of from the source. It requires a runtime to be embedded.
  '@babel/plugin-transform-for-of',
  // TODO: Remove array spread from the source. Prefer .apply instead.
  ['@babel/plugin-transform-spread', {loose: true, useBuiltIns: true}],
  '@babel/plugin-transform-parameters',
  // TODO: Remove array destructuring from the source. Requires runtime.
  ['@babel/plugin-transform-destructuring', {loose: true, useBuiltIns: true}],
  // Transform Object spread to shared/assign
  require('../babel/transform-object-assign'),
];

const babelToES5Plugins = [
  // These plugins transform DEV mode. Closure compiler deals with these in PROD.
  '@babel/plugin-transform-literals',
  '@babel/plugin-transform-arrow-functions',
  '@babel/plugin-transform-block-scoped-functions',
  '@babel/plugin-transform-shorthand-properties',
  '@babel/plugin-transform-computed-properties',
  ['@babel/plugin-transform-block-scoping', {throwIfClosureRequired: true}],
];

function getBabelConfig(
  updateBabelOptions,
  bundleType,
  packageName,
  externals,
  isDevelopment,
  bundle
) {
  const canAccessReactObject =
    packageName === 'react' || externals.indexOf('react') !== -1;
  let options = {
    exclude: '/**/node_modules/**',
    babelrc: false,
    configFile: false,
    presets: [],
    plugins: [...babelPlugins],
  };
  if (isDevelopment) {
    options.plugins.push(
      ...babelToES5Plugins,
      // Turn console.error/warn() into a custom wrapper
      [
        require('../babel/transform-replace-console-calls'),
        {
          shouldError: !canAccessReactObject,
        },
      ]
    );
  }
  if (updateBabelOptions) {
    options = updateBabelOptions(options);
  }
  // Controls whether to replace error messages with error codes in production.
  // By default, error messages are replaced in production.
  if (!isDevelopment && bundle.minifyWithProdErrorCodes !== false) {
    options.plugins.push(require('../error-codes/transform-error-messages'));
  }

  return options;
}

function getRollupOutputOptions(
  outputPath,
  format,
  globals,
  globalName,
  bundleType
) {
  const isProduction = isProductionBundleType(bundleType);

  return {
    file: outputPath,
    format,
    globals,
    freeze: !isProduction,
    interop: false,
    name: globalName,
    sourcemap: true,
    esModule: false,
  };
}

function getFormat(bundleType) {
  switch (bundleType) {
    case UMD_DEV:
    case UMD_PROD:
    case UMD_PROFILING:
      return `umd`;
    case NODE_ES2015:
    case NODE_DEV:
    case NODE_PROD:
    case NODE_PROFILING:
    case FB_WWW_DEV:
    case FB_WWW_PROD:
    case FB_WWW_PROFILING:
    case RN_OSS_DEV:
    case RN_OSS_PROD:
    case RN_OSS_PROFILING:
    case RN_FB_DEV:
    case RN_FB_PROD:
    case RN_FB_PROFILING:
      return `cjs`;
    case NODE_ESM:
      return `es`;
  }
}

function isProductionBundleType(bundleType) {
  switch (bundleType) {
    case NODE_ES2015:
    case NODE_ESM:
    case UMD_DEV:
    case NODE_DEV:
    case FB_WWW_DEV:
    case RN_OSS_DEV:
    case RN_FB_DEV:
      return false;
    case UMD_PROD:
    case NODE_PROD:
    case UMD_PROFILING:
    case NODE_PROFILING:
    case FB_WWW_PROD:
    case FB_WWW_PROFILING:
    case RN_OSS_PROD:
    case RN_OSS_PROFILING:
    case RN_FB_PROD:
    case RN_FB_PROFILING:
      return true;
    default:
      throw new Error(`Unknown type: ${bundleType}`);
  }
}

function isProfilingBundleType(bundleType) {
  switch (bundleType) {
    case NODE_ES2015:
    case NODE_ESM:
    case FB_WWW_DEV:
    case FB_WWW_PROD:
    case NODE_DEV:
    case NODE_PROD:
    case RN_FB_DEV:
    case RN_FB_PROD:
    case RN_OSS_DEV:
    case RN_OSS_PROD:
    case UMD_DEV:
    case UMD_PROD:
      return false;
    case FB_WWW_PROFILING:
    case NODE_PROFILING:
    case RN_FB_PROFILING:
    case RN_OSS_PROFILING:
    case UMD_PROFILING:
      return true;
    default:
      throw new Error(`Unknown type: ${bundleType}`);
  }
}

function forbidFBJSImports() {
  return {
    name: 'forbidFBJSImports',
    resolveId(importee, importer) {
      if (/^fbjs\//.test(importee)) {
        throw new Error(
          `Don't import ${importee} (found in ${importer}). ` +
            `Use the utilities in packages/shared/ instead.`
        );
      }
    },
  };
}

function getPlugins(
  entry,
  externals,
  updateBabelOptions,
  filename,
  packageName,
  bundleType,
  globalName,
  moduleType,
  pureExternalModules,
  bundle
) {
  const forks = Modules.getForks(bundleType, entry, moduleType, bundle);
  const isProduction = isProductionBundleType(bundleType);
  const isProfiling = isProfilingBundleType(bundleType);
  const isUMDBundle =
    bundleType === UMD_DEV ||
    bundleType === UMD_PROD ||
    bundleType === UMD_PROFILING;
  const isFBWWWBundle =
    bundleType === FB_WWW_DEV ||
    bundleType === FB_WWW_PROD ||
    bundleType === FB_WWW_PROFILING;
  const isRNBundle =
    bundleType === RN_OSS_DEV ||
    bundleType === RN_OSS_PROD ||
    bundleType === RN_OSS_PROFILING ||
    bundleType === RN_FB_DEV ||
    bundleType === RN_FB_PROD ||
    bundleType === RN_FB_PROFILING;
  const shouldStayReadable = isFBWWWBundle || isRNBundle || forcePrettyOutput;
  return [
    // Shim any modules that need forking in this environment.
    useForks(forks),
    // Ensure we don't try to bundle any fbjs modules.
    forbidFBJSImports(),
    // Use Node resolution mechanism.
    resolve({
      skip: externals,
    }),
    // Remove license headers from individual modules
    stripBanner({
      exclude: 'node_modules/**/*',
    }),
    // Compile to ES2015.
    babel(
      getBabelConfig(
        updateBabelOptions,
        bundleType,
        packageName,
        externals,
        !isProduction,
        bundle
      )
    ),
    // Remove 'use strict' from individual source files.
    // {
    //   transform(source) {
    //     return source.replace(/['"]use strict["']/g, '');
    //   },
    // },
    // Turn __DEV__ and process.env checks into constants.
    replace({
      __DEV__: isProduction ? 'false' : 'true',
      __PROFILE__: isProfiling || !isProduction ? 'true' : 'false',
      __UMD__: isUMDBundle ? 'true' : 'false',
      'process.env.NODE_ENV': isProduction ? "'production'" : "'development'",
      __EXPERIMENTAL__,
      // Enable forked reconciler.
      // NOTE: I did not put much thought into how to configure this.
      __VARIANT__: bundle.enableNewReconciler === true,
    }),
    // The CommonJS plugin *only* exists to pull "art" into "react-art".
    // I'm going to port "art" to ES modules to avoid this problem.
    // Please don't enable this for anything else!
    isUMDBundle && entry === 'react-art' && commonjs(),
    // Apply dead code elimination and/or minification.
    false &&
      closure(
        Object.assign({}, closureOptions, {
          // Don't let it create global variables in the browser.
          // https://github.com/facebook/react/issues/10909
          assume_function_wrapper: !isUMDBundle,
          renaming: !shouldStayReadable,
        })
      ),
    // HACK to work around the fact that Rollup isn't removing unused, pure-module imports.
    // Note that this plugin must be called after closure applies DCE.
    false && stripUnusedImports(pureExternalModules),
    // Add the whitespace back if necessary.
    shouldStayReadable &&
      prettier({
        parser: 'babel',
        singleQuote: false,
        trailingComma: 'none',
        bracketSpacing: true,
      }),
    // License and haste headers, top-level `if` blocks.
    // {
    //   renderChunk(source) {
    //     return Wrappers.wrapBundle(
    //       source,
    //       bundleType,
    //       globalName,
    //       filename,
    //       moduleType,
    //       bundle.wrapWithModuleBoundaries
    //     );
    //   },
    // },
    // Record bundle size.
    sizes({
      getSize: (size, gzip) => {
        const currentSizes = Stats.currentBuildResults.bundleSizes;
        const recordIndex = currentSizes.findIndex(
          record =>
            record.filename === filename && record.bundleType === bundleType
        );
        const index = recordIndex !== -1 ? recordIndex : currentSizes.length;
        currentSizes[index] = {
          filename,
          bundleType,
          packageName,
          size,
          gzip,
        };
      },
    }),
  ].filter(Boolean);
}

function shouldSkipBundle(bundle, bundleType) {
  const shouldSkipBundleType = bundle.bundleTypes.indexOf(bundleType) === -1;
  if (shouldSkipBundleType) {
    return true;
  }
  if (requestedBundleTypes.length > 0) {
    const isAskingForDifferentType = requestedBundleTypes.every(
      requestedType => bundleType.indexOf(requestedType) === -1
    );
    if (isAskingForDifferentType) {
      return true;
    }
  }
  if (requestedBundleNames.length > 0) {
    // If the name ends with `something/index` we only match if the
    // entry ends in something. Such as `react-dom/index` only matches
    // `react-dom` but not `react-dom/server`. Everything else is fuzzy
    // search.
    const entryLowerCase = bundle.entry.toLowerCase() + '/index.js';
    const isAskingForDifferentNames = requestedBundleNames.every(
      requestedName => {
        const matchEntry = entryLowerCase.indexOf(requestedName) !== -1;
        if (!bundle.name) {
          return !matchEntry;
        }
        const matchName =
          bundle.name.toLowerCase().indexOf(requestedName) !== -1;
        return !matchEntry && !matchName;
      }
    );
    if (isAskingForDifferentNames) {
      return true;
    }
  }
  return false;
}

function resolveEntryFork(resolvedEntry, isFBBundle) {
  // Pick which entry point fork to use:
  // .modern.fb.js
  // .classic.fb.js
  // .fb.js
  // .stable.js
  // .experimental.js
  // .js

  if (isFBBundle) {
    const resolvedFBEntry = resolvedEntry.replace(
      '.js',
      __EXPERIMENTAL__ ? '.modern.fb.js' : '.classic.fb.js'
    );
    if (fs.existsSync(resolvedFBEntry)) {
      return resolvedFBEntry;
    }
    const resolvedGenericFBEntry = resolvedEntry.replace('.js', '.fb.js');
    if (fs.existsSync(resolvedGenericFBEntry)) {
      return resolvedGenericFBEntry;
    }
    // Even if it's a FB bundle we fallthrough to pick stable or experimental if we don't have an FB fork.
  }
  const resolvedForkedEntry = resolvedEntry.replace(
    '.js',
    __EXPERIMENTAL__ ? '.experimental.js' : '.stable.js'
  );
  if (fs.existsSync(resolvedForkedEntry)) {
    return resolvedForkedEntry;
  }
  // Just use the plain .js one.
  return resolvedEntry;
}

async function createBundle(bundle, bundleType) {
  if (shouldSkipBundle(bundle, bundleType)) {
    return;
  }

  const filename = getFilename(bundle, bundleType);
  const logKey =
    chalk.white.bold(filename) + chalk.dim(` (${bundleType.toLowerCase()})`);
  const format = getFormat(bundleType);
  const packageName = Packaging.getPackageName(bundle.entry);

  const isFBWWWBundle =
    bundleType === FB_WWW_DEV ||
    bundleType === FB_WWW_PROD ||
    bundleType === FB_WWW_PROFILING;

  const isFBRNBundle =
    bundleType === RN_FB_DEV ||
    bundleType === RN_FB_PROD ||
    bundleType === RN_FB_PROFILING;

  let resolvedEntry = resolveEntryFork(
    require.resolve(bundle.entry),
    isFBWWWBundle || isFBRNBundle
  );

  const shouldBundleDependencies =
    bundleType === UMD_DEV ||
    bundleType === UMD_PROD ||
    bundleType === UMD_PROFILING;
  const peerGlobals = Modules.getPeerGlobals(bundle.externals, bundleType);
  let externals = Object.keys(peerGlobals);
  if (!shouldBundleDependencies) {
    const deps = Modules.getDependencies(bundleType, bundle.entry);
    externals = externals.concat(deps);
  }

  const importSideEffects = Modules.getImportSideEffects();
  const pureExternalModules = Object.keys(importSideEffects).filter(
    module => !importSideEffects[module]
  );

  const rollupConfig = {
    input: resolvedEntry,
    treeshake: {
      pureExternalModules,
    },
    external(id) {
      const containsThisModule = pkg => id === pkg || id.startsWith(pkg + '/');
      const isProvidedByDependency = externals.some(containsThisModule);
      if (!shouldBundleDependencies && isProvidedByDependency) {
        if (id.indexOf('/src/') !== -1) {
          throw Error(
            'You are trying to import ' +
              id +
              ' but ' +
              externals.find(containsThisModule) +
              ' is one of npm dependencies, ' +
              'so it will not contain that source file. You probably want ' +
              'to create a new bundle entry point for it instead.'
          );
        }
        return true;
      }
      return !!peerGlobals[id];
    },
    onwarn: handleRollupWarning,
    plugins: getPlugins(
      bundle.entry,
      externals,
      bundle.babel,
      filename,
      packageName,
      bundleType,
      bundle.global,
      bundle.moduleType,
      pureExternalModules,
      bundle
    ),
    output: {
      externalLiveBindings: false,
      freeze: false,
      interop: false,
      esModule: false,
    },
  };
  const mainOutputPath = Packaging.getBundleOutputPath(
    bundleType,
    filename,
    packageName
  );
  const rollupOutputOptions = getRollupOutputOptions(
    mainOutputPath,
    format,
    peerGlobals,
    bundle.global,
    bundleType
  );

  if (isWatchMode) {
    rollupConfig.output = [rollupOutputOptions];
    const watcher = rollup.watch(rollupConfig);
    watcher.on('event', async event => {
      switch (event.code) {
        case 'BUNDLE_START':
          console.log(`${chalk.bgYellow.black(' BUILDING ')} ${logKey}`);
          break;
        case 'BUNDLE_END':
          console.log(`${chalk.bgGreen.black(' COMPLETE ')} ${logKey}\n`);
          break;
        case 'ERROR':
        case 'FATAL':
          console.log(`${chalk.bgRed.black(' OH NOES! ')} ${logKey}\n`);
          handleRollupError(event.error);
          break;
      }
    });
  } else {
    console.log(`${chalk.bgYellow.black(' BUILDING ')} ${logKey}`);
    try {
      const result = await rollup.rollup(rollupConfig);
      await result.write(rollupOutputOptions);
    } catch (error) {
      console.log(`${chalk.bgRed.black(' OH NOES! ')} ${logKey}\n`);
      handleRollupError(error);
      throw error;
    }
    console.log(`${chalk.bgGreen.black(' COMPLETE ')} ${logKey}\n`);
  }
}

function handleRollupWarning(warning) {
  if (warning.code === 'UNUSED_EXTERNAL_IMPORT') {
    const match = warning.message.match(/external module '([^']+)'/);
    if (!match || typeof match[1] !== 'string') {
      throw new Error(
        'Could not parse a Rollup warning. ' + 'Fix this method.'
      );
    }
    const importSideEffects = Modules.getImportSideEffects();
    const externalModule = match[1];
    if (typeof importSideEffects[externalModule] !== 'boolean') {
      throw new Error(
        'An external module "' +
          externalModule +
          '" is used in a DEV-only code path ' +
          'but we do not know if it is safe to omit an unused require() to it in production. ' +
          'Please add it to the `importSideEffects` list in `scripts/rollup/modules.js`.'
      );
    }
    // Don't warn. We will remove side effectless require() in a later pass.
    return;
  }

  if (warning.code === 'CIRCULAR_DEPENDENCY') {
    // Ignored
  } else if (typeof warning.code === 'string') {
    // This is a warning coming from Rollup itself.
    // These tend to be important (e.g. clashes in namespaced exports)
    // so we'll fail the build on any of them.
    console.error();
    console.error(warning.message || warning);
    console.error();
    process.exit(1);
  } else {
    // The warning is from one of the plugins.
    // Maybe it's not important, so just print it.
    console.warn(warning.message || warning);
  }
}

function handleRollupError(error) {
  loggedErrors.add(error);
  if (!error.code) {
    console.error(error);
    return;
  }
  console.error(
    `\x1b[31m-- ${error.code}${error.plugin ? ` (${error.plugin})` : ''} --`
  );
  console.error(error.stack);
  if (error.loc && error.loc.file) {
    const {file, line, column} = error.loc;
    // This looks like an error from Rollup, e.g. missing export.
    // We'll use the accurate line numbers provided by Rollup but
    // use Babel code frame because it looks nicer.
    const rawLines = fs.readFileSync(file, 'utf-8');
    // column + 1 is required due to rollup counting column start position from 0
    // whereas babel-code-frame counts from 1
    const frame = codeFrame(rawLines, line, column + 1, {
      highlightCode: true,
    });
    console.error(frame);
  } else if (error.codeFrame) {
    // This looks like an error from a plugin (e.g. Babel).
    // In this case we'll resort to displaying the provided code frame
    // because we can't be sure the reported location is accurate.
    console.error(error.codeFrame);
  }
}

async function buildEverything() {
  if (!argv['unsafe-partial']) {
    await asyncRimRaf('build');
  }

  // Run them serially for better console output
  // and to avoid any potential race conditions.

  let bundles = [];
  // eslint-disable-next-line no-for-of-loops/no-for-of-loops
  for (const bundle of Bundles.bundles) {
    bundles.push(
      [bundle, NODE_ES2015],
      [bundle, NODE_ESM],
      [bundle, UMD_DEV],
      [bundle, UMD_PROD],
      [bundle, UMD_PROFILING],
      [bundle, NODE_DEV],
      [bundle, NODE_PROD],
      [bundle, NODE_PROFILING],
      [bundle, FB_WWW_DEV],
      [bundle, FB_WWW_PROD],
      [bundle, FB_WWW_PROFILING],
      [bundle, RN_OSS_DEV],
      [bundle, RN_OSS_PROD],
      [bundle, RN_OSS_PROFILING],
      [bundle, RN_FB_DEV],
      [bundle, RN_FB_PROD],
      [bundle, RN_FB_PROFILING]
    );
  }

  if (process.env.CIRCLE_NODE_TOTAL) {
    // In CI, parallelize bundles across multiple tasks.
    const nodeTotal = parseInt(process.env.CIRCLE_NODE_TOTAL, 10);
    const nodeIndex = parseInt(process.env.CIRCLE_NODE_INDEX, 10);
    bundles = bundles.filter((_, i) => i % nodeTotal === nodeIndex);
  }

  // eslint-disable-next-line no-for-of-loops/no-for-of-loops
  for (const [bundle, bundleType] of bundles) {
    await createBundle(bundle, bundleType);
  }

  await Packaging.copyAllShims();
  await Packaging.prepareNpmPackages();

  if (syncFBSourcePath) {
    await Sync.syncReactNative(syncFBSourcePath);
  } else if (syncWWWPath) {
    await Sync.syncReactDom('build/facebook-www', syncWWWPath);
  }

  console.log(Stats.printResults());
  if (!forcePrettyOutput) {
    Stats.saveResults();
  }
}

buildEverything();


```








