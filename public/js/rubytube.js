/*
  Copyright 2023.04 @github.com/motebaya
  Javacript API handler with jquery
  Source: @github.com/motebaya/rubytube-downloader
  Date: 2023.05.04 09:57:27 pm
  Docs: https://getbootstrap.com/docs/5.2/getting-started/introduction/
  JQ: https://api.jquery.com/
*/

// var res;
function stopbutton() {
  $("#tera-button").html("download");
}

// https://stackoverflow.com/a/196991/18108149
function toTitleCase(str) {
  return str.replace(/\w\S*/g, function (txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });
}

function Thumbnail(videoid) {
  $("#thumbnail").attr(
    "src",
    `https://img.youtube.com/vi/${videoid}/maxresdefault.jpg`
  );
}

$(function () {
  const cardinfo = $("div[id='card-info']");
  const tableresult = $("div[id='result']");
  cardinfo.hide();
  tableresult.hide();

  // lesgoo make a litle element wit JQ, if option server got change :3
  $("select[name='v-server']").on("change", function () {
    if ($(this).val() == "savetube") {
      if ($(this).next("label").length <= 0) {
        $(this).after($(`<label>`).addClass("form-label").text("type:"));
        ["Audio", "Video"].forEach((val, index) => {
          let input = $(`<input>`)
            .addClass("form-check-input")
            .attr({
              type: "radio",
              name: "formats",
              id: "flexRadioDefault" + (index + 1),
              value: val.toLowerCase(),
            })
            .prop("checked", index == 1);
          let labelCheck = $(`<label>`)
            .addClass("form-check-label")
            .text(`${val}`)
            .attr("for", "flexRadioDefault" + (index + 1));
          let thediv = $(`<div>`)
            .addClass("form-check")
            .append(input, labelCheck);
          $("form[id='teraform']").find("button").before(thediv);
        });
      }
    } else {
      // if you change the options but the element is exist then JQ wil delete it
      if ($(this).next("label").length > 0) {
        $(this).nextAll().slice(0, 3).remove();
      }
    }
  });

  $("form[id='teraform']").on("submit", function (event) {
    event.preventDefault();
    // show loading button: https://getbootstrap.com/docs/5.2/components/spinners/#buttons
    $("#tera-button").html(
      `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
  Loading...`
    );

    // check and delete existing element
    [
      cardinfo.find("ul li"),
      tableresult.find("table thead th"),
      tableresult.find("table tbody tr"),
    ].forEach((ele) => {
      if (ele.length > 0) {
        ele.remove();
      }
    });

    // find small tag if exist then delete it
    if (tableresult.find("small").length !== 0) {
      tableresult.find("small").remove();
    }

    // menhera dog :3
    $("#thumbnail").attr("src", "/image/menhera1.gif");
    let data = $(this).serializeArray();
    const youtubeURL = data[0].value;
    const server = data[1].value;
    if (
      (isurl = youtubeURL.match(
        new RegExp(
          /^(?:http(?:s)?:\/\/)?(?:www\.)?(?:m\.)?(?:youtu\.be\/|youtube\.com\/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user|shorts)\/))([^\?&\"'>]+)/
        )
      ))
    ) {
      const youtubeID = isurl[1];
      this.reset(); // reset form
      // menhera gone when Thumbnail called :<
      switch (server) {
        case "y2mate":
          $.get(`/${server}`, {
            url: youtubeURL,
          })
            .done(function (response) {
              stopbutton();
              Thumbnail(youtubeID);
              // res = response;
              if (response.success) {
                // start modify the element
                // add info
                cardinfo.show();
                ["author", "title"].forEach((val) => {
                  cardinfo
                    .find("ul")
                    .append(
                      `<li class="list-group-item">&#8226; ${val}: ${response[val]} </li>`
                    );
                });

                tableresult.show();
                tableresult.find("thead").append(
                  `<tr>
              <th scope="col">no</th>
                <th scope="col">Size</th>
                <th scope="col">Quality</th>
                <th scope="col">Format</th>
                <th scope="col">Download</th>
              </tr>`
                );

                // add the rows
                response["media"].forEach((tbl, index) => {
                  tableresult.find("tbody").append(
                    `<tr>
                <td>${index + 1}</td>
                <td>${tbl.size}</td>
                <td>${tbl.quality}</td>
                <td>${tbl.format}</td>
                <td style="text-align: center;" ><button type="submit" data-server="${server}" data-vid="${youtubeID}" data-token="${
                      tbl.key
                    }" class="btn btn-outline-secondary download-gas">download</button></td>
              </tr>`
                  );
                });
              }
            })
            .fail(function (error) {
              cardinfo.show();
              cardinfo.append(error.toString());
            });
          break;
        case "savetube":
          let formats = data[2].value;
          $.get(`/${server}`, {
            url: youtubeURL,
            f: formats,
          })
            .done(function (response) {
              stopbutton();
              Thumbnail(youtubeID);
              // res = response;
              if (response.success) {
                cardinfo.show();
                cardinfo
                  .find("ul")
                  .append(
                    `<li class="list-group-item">&#8226; Title: ${response.title} </li>`
                  );

                tableresult.show();
                tableresult.find("thead").append(
                  `<tr>
                <th scope="col">no</th>
                <th scope="col">Format</th>
                <th scope="col">Quality</th>
                <th scope="col">Download</th>
              </tr>`
                );
                response.res.forEach((val, index) => {
                  var quality = val.replace(/\s->\s/g, "x");
                  tableresult.find("tbody").append(
                    `<tr>
                <td>${index + 1}</td>
                <td>${response.format}</td>
                <td>${quality}</td>
                <td style="text-align: center;" ><button type="submit" data-server="${server}" data-vid="${
                      quality.split("x")[0]
                    }" data-token="${
                      response.key
                    }" class="btn btn-outline-secondary download-gas">download</button></td>
              </tr>`
                  );
                });
              }
            })
            .fail(function (error) {
              cardinfo.show();
              cardinfo.append(error.toString());
            });
          break;
        case "youtube":
          $.get(`/${server}`, {
            url: youtubeURL,
          })
            .done(function (response) {
              stopbutton();
              Thumbnail(youtubeID);
              // res = response;
              cardinfo.show();
              tableresult.show();
              tableresult.find("thead").append(
                `<tr>
                  <th scope="col">No</th>
                  <th scope="col">Type</th>
                  <th scope="col">Quality</th>
                  <th scope="col">Bitrate</th>
                  <th scope="col">Download</th>
                  </tr>`
              );

              Object.entries(response).forEach(([k, v], index) => {
                if (!["adaptive_formats", "formats"].includes(k)) {
                  cardinfo
                    .find("ul")
                    .append(
                      `<li class="list-group-item">&#8226; ${toTitleCase(
                        k
                      )}: ${v} </li>`
                    );
                }
              });

              var stream_formats = response.adaptive_formats;
              stream_formats.concat(response.adaptive_formats);
              // extend all formats
              stream_formats.forEach((val, index) => {
                tableresult.find("tbody").append(
                  `<tr>
                    <td>${index + 1}</td>
                    <td>${val.type}</td>
                    <td>${val.quality}</td>
                    <td>${val.bitrate}</td>
                  </tr>
                  `
                );

                if (val.link !== null) {
                  tableresult
                    .find("tbody tr")
                    .eq(index)
                    .append(
                      `<td style="text-align: center;" ><a rel="noopener norefferer nofollow" href="${val.link}" target="_blank" class="btn btn-outline-secondary">download</a></td>`
                    );
                } else {
                  tableresult
                    .find("tbody tr")
                    .eq(index)
                    .append(`<td style="align: center"> - </td>`);
                  // append the danger  info to table result if youtube can't get strean url:<
                  if (tableresult.find("small").length === 0) {
                    tableresult.find("h5").after(
                      $("<div>")
                        .addClass("text-center")
                        .append(
                          $(`<small>`, {
                            class: "text-danger",
                            html: 'youtube have issue with signature authorization <a href="#" target="_blank">see here</a> for more info.',
                          })
                        )
                    );
                  }
                }
              });
            })
            .fail(function (error) {
              cardinfo.show();
              cardinfo.append(error.toString());
            });
          break;
      }
    }
  });

  // handle converter /server?d=<ytid>&=t=<token>
  $(document).on("click", ".download-gas", function () {
    let $button = $(this);
    $button.text("converting..");
    $button.prop("disabled", true);
    let servername = $button.data("server");
    $.get(`/${servername}`, {
      d: $button.data("vid"),
      t: $button.data("token"),
    })
      .done(function (response) {
        // console.log(response);
        if (response.success) {
          $("<a>", {
            href:
              response.dlink !== undefined
                ? response.dlink
                : response.data.downloadUrl,
            target: "_blank",
            rel: "noreferrer nofollow noopener",
          })[0].click();
          $button.text("success...");
        } else {
          $button.text("failed convert!");
        }
      })
      .fail(function (e) {
        $button.text("failed convert!");
      });
  });
});
