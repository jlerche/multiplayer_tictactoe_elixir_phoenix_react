import React from 'react';
import {Socket} from "phoenix"

export default class Game extends React.Component {
    constructor() {
        super()
        this.state = {
            symbol: "",
            turn: false,
            board: [
                "", "", "", "", "", "", "", "", ""
            ],
            winner: null
        }

    }
    render () {
        const board_styles = {
            height: '460px',
            width: '460px',
            float: 'left',
            padding: '0',
            margin: '20 0 0 20'
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
            <div className="game-containder">
                <div className="board" style={board_styles}>
                    {this.state.board.map((cell, index) => {
                        return <div style={cell_styles} key={index}>{cell}</div>
                    })}
                </div>
            </div>
        )
    }
}
