import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = [ "username", "usernameTaken", "saveButton", "errorMessage"]

    checkUsername(event) {
        console.log('inher')
        const target = this.saveButtonTarget;
        console.log(this.usernameTarget.value.length )
        if (this.usernameTarget.value.length < 4 ) {
            console.log('less than 4');
            console.log(this.usernameTarget.value);
            this.errorMessageTarget.classList.remove("invisible")
            this.errorMessageTarget.innerHTML = 'Username must contain atleast 4 characters'
            target.disabled = true;
            target.classList.add("btn-disabled");
            target.classList.remove("btn-primary");
            return;
        } else if (/^[a-zA-Z0-9_]+$/.test(this.usernameTarget.value) == false) {
            this.errorMessageTarget.classList.remove("invisible")
            this.errorMessageTarget.innerHTML = 'Username can only contain letters,numbers or underscores'
            target.disabled = true;
            target.classList.add("btn-disabled");
            target.classList.remove("btn-primary");
            return;
        } else {
            console.log('more than 4');
            this.errorMessageTarget.classList.add("invisible")
            target.disabled = false;
            target.classList.remove("btn-disabled");
            target.classList.add("btn-primary");
        }   

        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        fetch('/onboarding/checkUsername', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken
            },
            body: JSON.stringify({ username: this.usernameTarget.value })
        })
        .then(response => response.json())
        .then(data => {
            
            if (data.status == 'error') {
                this.errorMessageTarget.classList.remove("invisible")
                this.errorMessageTarget.innerHTML = 'Username already taken'
                target.disabled = true;
                target.classList.add("btn-disabled");
                target.classList.remove("btn-primary");

            } else {
                
                this.errorMessageTarget.classList.add("invisible")
                target.disabled = false;
                target.classList.remove("btn-disabled");
                target.classList.add("btn-primary");
            }
        });


    }
}