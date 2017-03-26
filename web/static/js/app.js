import 'phoenix_html';
import * as Phoenix from 'phoenix';
import './spop';
import Elixir from './build/Elixir.App';

const socket = new Phoenix.Socket('/socket');
socket.connect();
const channel = socket.channel('client');
channel.join();
channel.on("action", function(msg) {
  Elixir.load(Elixir.Channels).dispatchMessage(msg);
});

Elixir.start(Elixir.Main, []);
