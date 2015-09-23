// Copyright 2015 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library w_module.example.panel.modules.reject_module;

import 'package:w_module/w_module.dart';
import 'package:w_flux/w_flux.dart';
import 'package:react/react.dart' as react;

class RejectModule extends Module {
  final String name = 'RejectModule';

  RejectActions _actions;
  RejectStore _stores;

  RejectComponents _components;
  RejectComponents get components => _components;

  RejectModule() {
    _actions = new RejectActions();
    _stores = new RejectStore(_actions);
    _components = new RejectComponents(_actions, _stores);
  }

  ShouldUnloadResult onShouldUnload() {
    if (_stores.shouldUnload) {
      return new ShouldUnloadResult();
    }
    return new ShouldUnloadResult(false, '${name} won\'t let you leave!');
  }
}

class RejectComponents implements ModuleComponents {
  RejectActions _actions;
  RejectStore _stores;

  RejectComponents(this._actions, this._stores);

  content() => RejectComponent({'actions': _actions, 'store': _stores});
}

class RejectActions {
  final Action toggleShouldUnload = new Action();
}

class RejectStore extends Store {
  /// Public data
  bool _shouldUnload = true;
  bool get shouldUnload => _shouldUnload;

  /// Internals
  RejectActions _actions;

  RejectStore(RejectActions this._actions) {
    triggerOnAction(_actions.toggleShouldUnload, _toggleShouldUnload);
  }

  _toggleShouldUnload(_) {
    _shouldUnload = !_shouldUnload;
  }
}

var RejectComponent = react.registerComponent(() => new _RejectComponent());

class _RejectComponent extends FluxComponent<RejectActions, RejectStore> {
  render() {
    return react.div({
      'style': {'padding': '50px', 'backgroundColor': 'green', 'color': 'white'}
    }, [
      'This module will reject unloading if the checkbox is cleared.',
      react.br({}),
      react.br({}),
      react.label({}, [
        react.input({
          'type': 'checkbox',
          'label': 'shouldUnload',
          'checked': store.shouldUnload,
          'onChange': actions.toggleShouldUnload
        }),
        'shouldUnload'
      ])
    ]);
  }
}
