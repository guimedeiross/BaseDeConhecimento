function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function teste(){ for(let i = 1; i <= 17; i++){ await sleep(1*1500); document.getElementById(`database${i}`).click(); } }