import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core.dart';

///
/// Utility class to read environment variables data
///
class EnvironmentReader {
  /// Local Yaml file content
  YamlMap? localEnv;

  /// Package location
  final String package;

  /// [EnvironmentReader] constructor
  EnvironmentReader(this.package);

  /// Loads an environment yaml file from local assets.
  /// The default location of this file is `.env` folder, at the root of the package.
  /// If [fromRootApp] is false, the [package] name will be used to load a file
  /// from a specific location (packages/<package_name>/.env)
  ///
  /// The Yaml file that is read depends on the current flavor - get from [Flavor.instance].
  /// The flavor corresponding file is:
  ///   - Prod: .env/env.yaml
  ///   - Develop: env/env_dev.yaml
  ///   - Homolog: env/env_hml.yaml
  Future<void> load() async {
    String file = '';

    try {
      WidgetsFlutterBinding.ensureInitialized();
      var suffix = Flavor.instance.type.name;
      suffix = suffix == FlavorType.prod.name ? '' : '_$suffix';

      file = 'assets/env/env$suffix.yaml';

      Log.d('loading $file');
      final data = await rootBundle.loadString(file);
      localEnv = await loadYaml(data);
    } catch (error) {
      Log.e('Failed to load $file', error);
    }
  }

  /// Reads a property by [name]
  /// If no value is found, the [fallback] is returned.
  String read(String name, {String fallback = ''}) {
    try {
      if (localEnv == null) {
        return fallback;
      }

      var keys = name.split('.');
      dynamic mapValue = localEnv!;
      for (dynamic key in keys) {
        mapValue = mapValue[key];
      }

      return mapValue ?? fallback;
    } catch (e) {
      Log.w('Property $name not found', e);
      return fallback;
    }
  }
}
