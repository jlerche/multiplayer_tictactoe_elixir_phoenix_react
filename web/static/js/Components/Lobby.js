import React from 'react';
import {Socket} from "phoenix";

export default class Lobby extends React.Component {
    constructor() {
        super();
        this.state = {
            games: []
        }
        this.renderGame = this.renderGame.bind(this);

    }
    componentDidMount() {
        let socket = new Socket("/socket");
        socket.connect()
        let lobbyChannel = socket.channel("lobby:lobby")
        lobbyChannel.on("foo", msg => {
            console.log("we dem boys")
        })
        lobbyChannel
            .join()
            .receive("ok", resp => {
                console.log("Joined")
                let games = resp.games
                this.setState({games})
            })
            .receive("error", reason => { console.log("error: ", reason)})
    }
    renderGame(game) {
        return (
            <tr>
                <td>{game.name}</td>
            </tr>
        )
    }
    render () {
        return (
            <table className="table">
                <thead>
                    <tr>
                        <th>Name</th>

                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>This is hardcoded!</td>
                    </tr>
                    {this.state.games.map(this.renderGame)}
                </tbody>
            </table>
        )
    }
}
