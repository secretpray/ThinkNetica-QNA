document.addEventListener('turbolinks:load', function() {

    // Hide/Unhide Gist block full view  
  document.body.addEventListener("click", function (event) {
    if (event.target.classList.contains('gist-button')) {
    const buttonGist = event.target 
    event.preventDefault();
    sectionGist = buttonGist.nextElementSibling
    
    if (sectionGist && sectionGist.classList.contains('hide')) {
        buttonGist.innerText = 'Hide gist'
        sectionGist.classList.remove('hide')
    } else {
        buttonGist.innerText = 'Show gist'
        sectionGist.classList.add('hide')
    }

    // Create an iframe, append it to this document where specified
    const gistFrame = document.createElement("iframe");
    gistFrame.setAttribute("width", "100%");
    gistFrame.setAttribute("height", "100%")
    gistFrame.id = "gistFrame";
    
    sectionGist.innerHTML = "";
    sectionGist.appendChild(gistFrame);

    // let gistIdValue = "1e6b5a46ff7b54befcae4b0daf000469" 
    let gistIdValue = buttonGist.parentNode.lastElementChild.dataset.srcId
    
    // Create the iframe's document
    //var gistFrameHTML = '<html><body onload="resizeIframe(this)"><scr' + 'ipt type="text/javascript" src="https://gist.github.com/' + gistIdValue + '.js"></sc'+'ript></body></html>';
    var gistFrameHTML = '<html><body onload=""><scr' + 'ipt type="text/javascript" src="https://gist.github.com/' + gistIdValue + '.js"></sc'+'ript></body></html>';
    
    // Set iframe's document with a trigger for this document to adjust the height
    var gistFrameDoc = gistFrame.document;
    

    if (gistFrame.contentDocument) {
        gistFrameDoc = gistFrame.contentDocument;
    } else if (gistFrame.contentWindow) {
        gistFrameDoc = gistFrame.contentWindow.document;
    }
    
    gistFrameDoc.open();
    gistFrameDoc.writeln(gistFrameHTML);
    gistFrameDoc.close();		
    
    }
  });
})