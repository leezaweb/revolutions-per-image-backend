function searchArtist(e){
  e.preventDefault();
  document.querySelector("article").innerHTML = "";
  let query = document.getElementById("add").value.toLowerCase();

  fetch(`https://api.discogs.com/database/search?q=${query}&page=1&credit&token=${token}`)
  .then(resp=>resp.json())
  .then(json=>{
    let selected = [];

    json.results.slice(0,25).filter(result=>{
      if (result.resource_url.includes("releases")){

        fetcher(result.resource_url).then(album=>{
          if(album!==undefined){
            selected.push(makeTempAlbum(album));
            }

        }).then(selectedVal=>{
          tempAdd(selected);
        });
      }
    });
  }).then(selectedVal=>{
    console.log(selectedVal.length);
    selected.forEach(album=>{
      document.querySelector("article").innerHTML += album.tempRender();
      document.querySelector(".pager").style.display = "none";
    });
    });

  document.getElementById("addForm").reset();
}
