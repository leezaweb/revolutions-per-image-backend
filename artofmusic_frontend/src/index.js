let search = false;
document.addEventListener('DOMContentLoaded', () => {
  Album.deleteIt();
  M.Modal.init(document.querySelectorAll('.modal'), {
    opacity: 0.5,
    inDuration: 600
  });
  M.Autocomplete.init(document.querySelectorAll('.autocomplete'), {});
  let instance = M.TapTarget.init(document.querySelectorAll('.tap-target'))[0];

  Genre.renderChips();
  VisualArtist.renderArtists();
  reRender();

  addPager();

  document.getElementById("sort").addEventListener('click', clickSort.bind(this));
  document.getElementById("chips").addEventListener('click', clickChip.bind(this));
  document.getElementById("searchForm").addEventListener('submit', searchIt.bind(this));
  document.getElementById("filterForm").addEventListener('submit', filterIt.bind(this));
  document.getElementById("addForm").addEventListener('submit', searchArtist.bind(this));
  document.querySelector("article").addEventListener('click', clickIt.bind(this));
  document.querySelector("article").addEventListener('click', likeIt.bind(this));
  document.querySelector("article").addEventListener('click', addIt.bind(this));
  document.querySelector(".discover-it").addEventListener('click', discoverIt.bind(this, instance));
  document.querySelector("main").addEventListener('click',function(e){
    instance.close();
    search = false;
  });
});

let token = "QjkhoqmubxdAFOTXhcXCnhdQzozszdFQOjFVltZN";
let count = 0;

function searchArtist(e){
  e.preventDefault();
  document.querySelector("article").innerHTML = "";
  let query = document.getElementById("add").value.toLowerCase();
  fetch(`https://api.discogs.com/database/search?q=${query}&?credit&token=${token}`)
  .then(resp=>resp.json())
  .then(json=>{
    let selected = [];

    json.results.slice(0,25).filter(result=>{
      if (result.resource_url.includes("releases")){
        fetcher(result.resource_url).then(album=>{
          if(album!==undefined){
          let artist = album.extraartists.find(ea=>{
            return ea.role.match(/\b(Cover|Painting|Artwork|Illustration|Drawing)\b/gi);
          });

          let genres = [];

          if (album.genres)album.genres.forEach(genre=>genres.push(genre));
          if (album.styles)album.styles.forEach(genre=>genres.push(genre));

          let artistObj = new VisualArtist(null,artist.name);

          genreObjs = genres.map(genre=>{
            new Genre(
              null,
              genre.name
            );
          });

          selected.push(new Album(
            null,
            album.artists_sort,
            album.title,
            album.images[0].uri,
            album.year,
            album.community.rating.average,
            album.community.rating.count,
            artistObj,
            genreObjs
          ));
          return selected;
            }
        }).then(selectedVal=>{
          // console.log(selectedVal.length);
          selected.forEach(album=>{
            document.querySelector("article").innerHTML += album.tempRender();
            document.querySelector(".pager").style.display = "none";
          });

        });
      }
    });
  });
  document.getElementById("addForm").reset();
}





function fetcher(result){
  let counter = 0;
  return fetch (`${result}?token=${token}`).then(resp=>resp.json()).then(json=>{
      counter = json.extraartists.filter(va=>{
        return va.role.match(/\b(Cover|Painting|Artwork|Illustration|Drawing)\b/gi);
      }).length;
      if (counter > 0){
        return json;
      }
    });
}


function clickSort(e) {
  clearSelected();
  if (e.target.className.includes("like-sort")) {
    reRender("likes");
  } else if (e.target.className.includes("year-sort")) {
    reRender("year");
  }
}

function discoverIt(instance, e) {
  if (e.target.className.includes("discovery")) {
    toggleDiscovery(instance);
  }
}

function toggleDiscovery(instance){
  if (search === false) {
    instance.open();
    search = true;
  } else {
    instance.close();
    search = false;
  }
  document.querySelectorAll(".pulse").forEach(pulse=>pulse.classList.toggle("pulse"));
}

function clickIt(e) {
  if (e.target.className.includes('image')) {
    let src = e.target.src;
    let vaId = e.target.dataset.artist;
    let albumId = e.target.dataset.id;
    VisualArtist.domDetail(albumId, vaId, src);
  }
}

function likeIt(e) {
  if (e.target.className.includes('like')) {
    e.target.parentElement.getElementsByClassName("likes")[0].innerHTML++;
    let id = e.target.dataset.id;

    Album.updateLikes(id);
  }
}

function addIt(e) {
  if (e.target.parentElement.className.includes('add')) {
    let data = ""
    fetch("http://localhost:3000/api/v1/albums",{
      body: JSON.stringify(data),
      method:"POST",
      headers: {
      'user-agent': 'Mozilla/4.0 MDN Example',
      'content-type': 'application/json'
    }}).then(resp=>resp.json()).then(json=>{
      debugger;
    });
  }
}

function clickChip(e) {
  if (e.target.className.includes('chip') && e.target.id !== "chips") {
    document.querySelectorAll("#sort .selected").forEach(chip=>chip.classList.remove("selected"));
    e.target.classList.toggle("selected");
    let clicked = [...document.querySelectorAll(".selected")].map(chip => {
      return parseInt(chip.dataset.id);
    });

    if (clicked.length == 0) {
      reRender();
    } else {
      Genre.filterAlbums(clicked);
    }
  }
}

function navigate(e, id) {
  let currentIndex = Album.page.indexOf(Album.page.find(album => {
    return album.id === parseInt(id);
  }));
  let nextIndex = ++currentIndex;
  let previousIndex = --currentIndex;
  if (e.key === "ArrowRight" || e.target.className.includes("chevron-right")) {
    currentIndex = nextIndex;
    VisualArtist.domDetail(Album.page[nextIndex].id);
  } else if (e.key === "ArrowLeft" || e.target.className.includes("chevron-left")) {
    currentIndex = --previousIndex;
    VisualArtist.domDetail(Album.page[previousIndex].id);
  }
}

function reRender(arg) {
  if (arguments.length && typeof arguments[0] === "object") {
    let allAlbums = arg.map(album => {
      return album.render();
    }).join("");
    document.querySelector("article").innerHTML = allAlbums;
    if (arg.length > 100) {
      addPager();
    } else {
      document.querySelector(".pager").style.display = "none";

    }

    checkCount();

    M.Tooltip.init(document.querySelectorAll('.tooltipped'), {});

  } else if (!isNaN( parseInt(arg)) || !arg) {
    document.querySelector(".progress").style.display = "block";
    fetch(`http://localhost:3000/api/v1/albums/?page=${arg}`).then(resp => resp.json()).then(json => {
      let theseAlbums = json.map(album => {
        return Album.makeAlbum(album);
      });
      updateDom(theseAlbums);
      addPager(arg);

    });
  } else if (typeof arg === "string") {
    document.querySelector(".progress").style.display = "block";
    fetch(`http://localhost:3000/api/v1/albums/?sort=${arg}`).then(resp => resp.json()).then(json => {
      let theseAlbums = json.map(album => {
        return Album.makeAlbum(album);
      });
      updateDom(theseAlbums);
    });

  }

  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0;
}

function updateDom(theseAlbums) {
  Album.page = theseAlbums;

  let allAlbums = Album.page.map(album => {
    return album.render();
  }).join("");

  document.querySelector("article").innerHTML = allAlbums;

  document.querySelector(".pager").style.display = "block";
  document.querySelector(".progress").style.display = "none";
  M.Tooltip.init(document.querySelectorAll('.tooltipped'), {});

}

function checkCount() {
  let count = document.querySelectorAll("summary").length;
  if (count === 0) {
    setTimeout(function(){document.querySelector("article").innerHTML = "no results";},1000);

  }
}

function addPager(arg = 1) {
  fetch("http://localhost:3000/api/v1/albums/count").then(resp => resp.json()).then(json => {
    let pages = Math.ceil(json.count / 18);
    let lis = "";
    for (i = 1; i <= pages; i++) {
      if (arg === i) {
        lis += `<li class="waves-effect active"><a>${i}</a></li>`;
      } else {
        lis += `<li class="waves-effect"><a>${i}</a></li>`;
      }
    }

    let pager = `<ul class="pagination">
        ${lis}
      </ul>`;

    document.querySelector(".pager").innerHTML = pager;

    document.querySelector(".pagination").addEventListener('click', function(e) {
      if (e.target.tagName === "A") {
        reRender(parseInt(e.target.textContent));
      }
    });
  });
}


function searchIt(e) {
  e.preventDefault();
  let query = document.getElementById("search").value.toLowerCase();
  clearSelected();
  Album.searchAlbums(query);
}

function filterIt(e) {
  e.preventDefault();
  let query = document.getElementById("autocomplete-input").value.toLowerCase();
  clearSelected();
  VisualArtist.filterAlbums(query);
}

function clearSelected(){
  document.getElementById("searchForm").reset();
  document.getElementById("filterForm").reset();

  document.querySelectorAll(".selected").forEach(chip=>chip.classList.remove("selected"));
}
