// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import React from 'react';
import {render} from "react-dom";

class HelloWorld extends React.Component {
    render () {
        return (
            <h1>Hello World!</h1>
        )
    }
}

let hello_world_element = document.getElementById("hello-world")
if (hello_world_element) {
    render(<HelloWorld />, hello_world_element)
}

import Lobby from './Components/Lobby';

let game_lobby_element = document.getElementById("game-lobby");
if (game_lobby_element) {
    render(<Lobby />, game_lobby_element)
}

import Game from './Components/Game';

let game_element = document.getElementById("game");
if (game_element) {
    render(<Game />, game_element)
}
