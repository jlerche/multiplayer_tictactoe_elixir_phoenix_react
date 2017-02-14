import React from 'react';
import {Socket, Presence} from "phoenix"

export default class Game extends React.Component {
    constructor() {
        super()
        this.state = {
            symbol: "",
            turn: false,
            board: [
                "", "", "", "", "", "", "", "", ""
            ],
            winner: null,
            players: {},
            player: "",
            id: ""
        }
        this.renderPlayers = this.renderPlayers.bind(this)
        this.channel = null

    }
    componentDidMount() {
        this.channel = this.setupChannel()
    }
    getUsername() {
        let userName = local
    }
    setupChannel() {
        let socket = new Socket("/socket");
        socket.connect()
        let game_id = document.getElementById("game-id").value
        let channel = socket.channel("game:" + game_id)
        channel.on('presence_diff', diff => {
            let players = this.state.players
            players = Presence.syncDiff(players, diff)
            this.setState({players})
        })
        channel.on('presence_state', state => {
            let players = this.state.players
            players = Presence.syncState(players, state)
            this.setState({players})
        })
        channel.on('init_sync', payload => {
            console.log(payload)
            let player = payload.player
            let turn = payload.game.turn
            turn = player === "player_one" ? true : false
            let symbol = this.getSymbol(player)
            let id = payload.game.id
            let board = payload.game.board
            this.setState({player,turn, symbol, id, board})
        })
        channel.on('state_update', payload => {
            console.log(payload)
            let board = payload.board
            let player = this.state.player
            let turn = player == payload.turn ? true : false
            let winner = payload.winner
            this.setState({turn, winner, board})

        })
        channel.join()
            .receive("ok", resp => {console.log("Joined", resp)})
            .receive("error", resp => {console.log("unable to join", resp)})
        return channel
    }
    getSymbol(player) {
        if (player === 'player_one') {
            return "X"
        } else {
            return "O"
        }
    }
    handleClick(index) {
        if(this.state.board[index] === "" && !this.state.winner && this.state.turn) {
            let board = this.state.board
            board[index] = this.state.symbol
            this.channel.push('new_move', {game_id: this.state.id, board: board,
                player: this.state.player})
        }
    }
    renderPlayers(player) {
        return (
            <li key={player.user}>{`${player.user}`}</li>
        )
    }
    render () {
        const board_styles = {
            height: '460px',
            width: '460px',
            float: 'left',
            padding: '0',
            margin: '20 0 0 20',
        }
        const cell_styles = {
            width: '150px',
            height: '150px',
            border: '1px solid black',
            float: 'left',
            lineHeight: '140px',
            textAlign: 'center',
            fontSize: '100px'
        }
        return(
            <div className="game-container">
                <div className="row">
                    <div className="col-8">
                        <div className="board" style={board_styles}>
                            {this.state.board.map((cell, index) => {
                                return <div style={cell_styles} key={index}
                                    onClick={() => this.handleClick(index)}>{cell}</div>
                            })}
                        </div>
                    </div>
                    <div className="col-4">
                        <div>
                            <div className="heading">
                                Online Users:
                            </div>
                            <div id="game-users">
                                {Presence.list(this.state.players, (user) => {
                                    return { user: user}
                                }).map(player => this.renderPlayers(player))}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}
