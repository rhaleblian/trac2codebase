        if False:    
            doc = Document()
            root = doc.createElement("ticket")
            doc.appendChild(root)
            
            e = doc.createElement("summary")
            t = doc.createTextNode(escape(summary))
            e.appendChild(t)
            root.appendChild(e)
            
            e = doc.createElement("reporter")
            t = doc.createTextNode(escape(owner))
            e.appendChild(t)
            root.appendChild(e)
            
            e = doc.createElement("ticket-type")
            t = doc.createTextNode(escape(typee))
            e.appendChild(t)
            root.appendChild(e)
            
            print doc.toprettyxml(indent="  ")

