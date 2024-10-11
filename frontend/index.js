import { backend } from 'declarations/backend';

let gameState = null;

async function initGame() {
    await backend.initGame(4); // Initialize game with 4 players
    await updateGameState();
    renderBoard();
    renderPlayerInfo();
}

async function updateGameState() {
    gameState = await backend.getGameState();
}

function renderBoard() {
    const board = document.getElementById('board');
    board.innerHTML = '';
    if (!gameState) return;

    gameState.board.forEach((row, y) => {
        row.forEach((tile, x) => {
            const tileElement = document.createElement('div');
            tileElement.className = 'tile';
            tileElement.textContent = tile.resource ? tile.resource[0].toUpperCase() : 'D';
            tileElement.dataset.x = x;
            tileElement.dataset.y = y;
            tileElement.addEventListener('click', () => buildSettlement(x, y));
            board.appendChild(tileElement);
        });
    });
}

function renderPlayerInfo() {
    const playerInfo = document.getElementById('player-info');
    playerInfo.innerHTML = '';
    if (!gameState) return;

    const currentPlayer = gameState.players[gameState.currentPlayer];
    const playerElement = document.createElement('div');
    playerElement.innerHTML = `
        <h2>Player ${currentPlayer.id}</h2>
        <p>Resources:</p>
        <ul>
            ${currentPlayer.resources.map(([resource, amount]) => `
                <li>${resource[0]}: ${amount}</li>
            `).join('')}
        </ul>
        <p>Buildings: ${currentPlayer.buildings.length}</p>
    `;
    playerInfo.appendChild(playerElement);
}

async function buildSettlement(x, y) {
    const success = await backend.buildSettlement(gameState.currentPlayer, x, y);
    if (success) {
        await updateGameState();
        renderBoard();
        renderPlayerInfo();
    } else {
        alert('Cannot build settlement here');
    }
}

async function endTurn() {
    await backend.endTurn();
    await updateGameState();
    renderPlayerInfo();
}

document.getElementById('build-settlement').addEventListener('click', () => {
    alert('Click on a tile to build a settlement');
});

document.getElementById('end-turn').addEventListener('click', endTurn);

initGame();
