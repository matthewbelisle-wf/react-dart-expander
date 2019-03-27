import "dart:async";

import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as react_dom;

class _HelloComponent extends react.Component {
  void componentWillReceiveProps(nextProps) {
    if (nextProps["name"].length > 20) {
      print("Too long Hello!");
    }
  }

  render() {
    return react.span({}, ["Hello ${props['name']}!"]);
  }
}

var helloComponent = react.registerComponent(() => new _HelloComponent());

class _HelloGreeter extends react.Component {
  var myInput;
  getInitialState() => {"name": "World"};

  onInputChange(e) {
    var input = react_dom.findDOMNode(myInput);
    print(input.borderEdge);
  }

  render() {
    return react.div({}, [
      react.input({
        'key': 'input',
        'className': 'form-control',
        'ref': (ref) => myInput = ref,
        'value': bind('name'),
        'onChange': onInputChange,
      }),
      helloComponent({'key': 'hello', 'name': state['name']})
    ]);
  }
}

var helloGreeter = react.registerComponent(() => new _HelloGreeter());

class _CheckBoxComponent extends react.Component {
  getInitialState() => {"checked": false};

  change(e) {
    this.setState({'checked': e.target.checked});
  }

  render() {
    return react.div({
      'className': 'form-check'
    }, [
      react.input({
        'id': 'doTheDishes',
        'key': 'input',
        'className': 'form-check-input',
        'type': 'checkbox',
        'value': bind('checked'),
      }),
      react.label({
        'htmlFor': 'doTheDishes',
        'key': 'label',
        'className': 'form-check-label ' + (this.state['checked'] ? 'striked' : 'not-striked')
      }, 'do the dishes'),
    ]);
  }
}

var checkBoxComponent = react.registerComponent(() => new _CheckBoxComponent());

class _ClockComponent extends react.Component {
  Timer timer;

  getInitialState() => {'secondsElapsed': 0};

  Map getDefaultProps() => {'refreshRate': 1000};

  void componentWillMount() {
    timer = new Timer.periodic(new Duration(milliseconds: this.props["refreshRate"]), this.tick);
  }

  void componentWillUnmount() {
    timer.cancel();
  }

  void componentDidMount() {
    var rootNode = react_dom.findDOMNode(this);
    rootNode.style.backgroundColor = "#FFAAAA";
  }

  bool shouldComponentUpdate(nextProps, nextState) {
    //print("Next state: $nextState, props: $nextProps");
    //print("Old state: $state, props: $props");
    return nextState['secondsElapsed'] % 2 == 1;
  }

  void componentWillReceiveProps(nextProps) {
    print("Received props: $nextProps");
  }

  tick(Timer timer) {
    setState({'secondsElapsed': state['secondsElapsed'] + 1});
  }

  render() {
    return react.span({'onClick': (event) => print("Hello World!")},
//        { 'onClick': (event, [domid = null]) => print("Hello World!") },
        ["Seconds elapsed: ", "${state['secondsElapsed']}"]);
  }
}

var clockComponent = react.registerComponent(() => new _ClockComponent());

class _ListComponent extends react.Component {
  Map getInitialState() {
    return {
      "items": new List.from([0, 1, 2, 3])
    };
  }

  void componentWillUpdate(nextProps, nextState) {
    if (nextState["items"].length > state["items"].length) {
      print("Adding " + nextState["items"].last.toString());
    }
  }

  void componentDidUpdate(prevProps, prevState) {
    if (prevState["items"].length > state["items"].length) {
      print("Removed " + prevState["items"].first.toString());
    }
  }

  int iterator = 3;

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(++iterator);
    setState({"items": items});
  }

  dynamic render() {
    List<dynamic> items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": item}, "$item"));
    }

    return react.div({}, [
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': addItem,
      }, 'addItem'),
      react.ul({'key': 'list'}, items),
    ]);
  }
}

var listComponent = react.registerComponent(() => new _ListComponent());

class _MainComponent extends react.Component {
  render() {
    return react.div({}, props['children']);
  }
}

var mainComponent = react.registerComponent(() => new _MainComponent());

class _ContextComponent extends react.Component {
  @override
  Iterable<String> get childContextKeys => const ['foo', 'bar', 'renderCount'];

  @override
  Map<String, dynamic> getChildContext() => {
        'foo': {'object': 'with value'},
        'bar': true,
        'renderCount': this.state['renderCount']
      };

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': _onButtonClick,
      }, 'Redraw'),
      react.br({'key': 'break1'}),
      'ContextComponent.getChildContext(): ',
      getChildContext().toString(),
      react.br({'key': 'break2'}),
      react.br({'key': 'break3'}),
      props['children'],
    ]);
  }

  _onButtonClick(event) {
    this.setState({'renderCount': (this.state['renderCount'] ?? 0) + 1});
  }
}

var contextComponent = react.registerComponent(() => new _ContextComponent());

class _ContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['foo'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'ContextConsumerComponent.context: ',
      context.toString(),
      react.br({'key': 'break1'}),
      react.br({'key': 'break2'}),
      props['children'],
    ]);
  }
}

var contextConsumerComponent = react.registerComponent(() => new _ContextConsumerComponent());

class _GrandchildContextConsumerComponent extends react.Component {
  @override
  Iterable<String> get contextKeys => const ['renderCount'];

  render() {
    return react.ul({
      'key': 'ul'
    }, [
      'GrandchildContextConsumerComponent.context: ',
      context.toString(),
    ]);
  }
}

var grandchildContextConsumerComponent = react.registerComponent(() => new _GrandchildContextConsumerComponent());

class _Component2TestComponent extends react.Component2 with react.TypedSnapshot<String> {
  Map getInitialState() {
    return {
      "items": new List.from([0, 1, 2, 3])
    };
  }

  String getSnapshotBeforeUpdate(nextProps, prevState) {
    if (prevState["items"].length > state["items"].length) {
      return "removed " + prevState["items"].last.toString();
    } else {
      return "added " + state["items"].last.toString();
    }
  }

  void componentDidUpdate(prevProps, prevState, [String snapshot]) {
    if (snapshot != null) {
      print('Updated DOM and ' + snapshot);
      return null;
    }
    print("No Snapshot");
  }

  void removeItem(event) {
    List items = new List.from(state["items"]);
    items.removeAt(items.length - 1);
    setState({"items": items});
  }

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(items.length);
    setState({"items": items});
  }

  dynamic render() {
    List<dynamic> items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": "c2" + item.toString()}, "$item"));
    }

    return react.div({}, [
      react.button({
        'type': 'button',
        'key': 'c2-r-button',
        'className': 'btn btn-primary',
        'onClick': removeItem,
      }, 'Remove Item'),
      react.button({
        'type': 'button',
        'key': 'c2-a-button',
        'className': 'btn btn-primary',
        'onClick': addItem,
      }, 'Add Item'),
      react.ul({'key': 'c2-list'}, items),
    ]);
  }
}

var component2TestComponent = react.registerComponent(() => new _Component2TestComponent());

class _ErrorComponent extends react.Component2 {

  void error(event) {

  }

  void componentDidMount(){
    print('Error Component props');
    print(props);
    print("Error Component Mounted");
    if (props["errored"]) {

    } else {

      print("Error Component throwing");
      throw new _JoesException("Itsa Broken", 2);
    }
  }

  dynamic render(){
    return react.div({'key': 'c3-d1-e'}, [
      react.button({
        'type': 'button',
        'key': 'c3-e-button',
        'className': 'btn btn-primary',
        'onClick': error,
      }, 'Error')
    ]);
  }
}

class _JoesException implements Exception {
  int code;
  String message;
  String randoMessage;

  _JoesException(this.message, this.code) {
    switch(code) {
      case 1:
        randoMessage = "The code is a 1";
        break;
      case 2:
        randoMessage = "The Code is a 2";
        break;
      default:
        randoMessage = "Whaaaaaa";
    }
  }

}

var ErrorComponent = react.registerComponent(() => new _ErrorComponent
  ());

class _Component2ErrorTestComponent extends react.Component2 with react
    .TypedSnapshot<String> {
  Map getInitialState() {
    return {
      "items": new List.from([0, 1, 2, 3]),
      "errored": false,
    };
  }

  String getSnapshotBeforeUpdate(nextProps, prevState) {


    if (prevState["items"].length > state["items"].length) {
      return "removed " + prevState["items"].last.toString();
    } else if (prevState["items"].length < state["items"].length){
      return "added " + state["items"].last.toString();
    }

    return null;
  }

  componentDidMount(){
    print("Mounted!");
  }


  void componentDidCatch(error, info){

  }

  Map getDerivedStateFromError(error){
//    _JoesException error1 = error;

    print("error");
    print(error.runtimeType);
//    print(error1.runtimeType);
//    print(error?.code);
//    print(error?.randoMessage);

//    print(error["Symbol(_thrownValue)"].message);
    print(error.stack);
    print(error);
    print(error.toString());
    return { "errored" : true };
  }

  void componentDidUpdate(prevProps, prevState, [String snapshot]) {
    if (snapshot != null) {
      print('Updated DOM and ' + snapshot);
      return null;
    }
    print("last state");
    print(prevState);
    print("next state");
    print(state);
  }

  void removeItem(event) {
    List items = new List.from(state["items"]);
    items.removeAt(items.length - 1);
    setState({"items": items});
  }

  void addItem(event) {
    List items = new List.from(state["items"]);
    items.add(items.length);
    setState({"items": items});
  }



  dynamic render() {
    List<dynamic> items = [];
    for (var item in state['items']) {
      items.add(react.li({"key": "c4" + item.toString()}, "$item"));
    }

    print('state');
    print(state);

    return react.div({}, [
      ErrorComponent({'key': 'ec-1', 'errored':
      state['errored']}),
      react.button({
        'type': 'button',
        'key': 'c3-r-button',
        'className': 'btn btn-primary',
        'onClick': removeItem,
      }, 'Remove Item'),
      react.button({
        'type': 'button',
        'key': 'c3-a-button',
        'className': 'btn btn-primary',
        'onClick': addItem,
      }, 'Add Item'),
      react.ul({'key': 'c3-list'}, items),
    ]);
  }
}

var component2ErrorTestComponent = react.registerComponent(() => new
_Component2ErrorTestComponent());
