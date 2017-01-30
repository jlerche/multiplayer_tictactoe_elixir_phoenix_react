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
        let lobbyChannel = this.setupChannel()
    }
    setupChannel() {
        let socket = new Socket("/socket");
        socket.connect()
        let lobbyChannel = socket.channel("lobby:lobby")
        lobbyChannel.on("add_game", game => {
            let games = this.state.games
            games.push(game)
            this.setState({games})
        })
        lobbyChannel.on("rem_game", game => {
            let games = this.state.games
            games = games.filter((el) => el.id !== game.id)
            this.setState({games})
        })
        lobbyChannel
            .join()
            .receive("ok", resp => {
                console.log("Joined")
                let games = resp.games
                this.setState({games})
            })
            .receive("error", reason => { console.log("error: ", reason)})
        return lobbyChannel
    }
    renderGame(game) {
        return (
            <tr key={game.id}>
                <td key={game.id}><a href={`${window.location.pathname}/${game.id}`}>{game.name}</a></td>
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
