import 'phoenix_html';
import * as Phoenix from 'phoenix';
import './spop';
import Elixir from './build/Elixir.App';
import React from 'react';

React.createElementArray = function(tag, attributes, children) {
  return React.createElement(tag, attributes, ...children);
};

const socket = new Phoenix.Socket('/socket');
socket.connect();
const channel = socket.channel('client');
channel.join();
channel.on("action", function(msg) {
  Elixir.load(Elixir.Client.Channels).dispatchMessage(msg);
});

Elixir.start(Elixir.Client, []);
