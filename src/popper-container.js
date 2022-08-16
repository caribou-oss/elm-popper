import { createPopper } from "@popperjs/core"

export class PopperContainer extends HTMLElement {
    static observedAttributes = ['data-placement', 'data-strategy', 'data-options']

    connectedCallback() {
        requestAnimationFrame(() => this.setup())
    }

    disconnectedCallback() {
        this.teardown()
    }

    attributeChangedCallback(name, oldVal, newVal) {
        if (oldVal !== newVal) {
            this.teardown()
            this.setup()
        }
    }

    teardown() {
        if (this.poll) {
            clearTimeout(this.poll)
        }
        if (this.popper) {
            this.popper.destroy()
        }
    }

    setup() {
        const tooltipElement = document.getElementById(this.getAttribute('data-tooltip-id'))
        const annotatedElement = this.firstElementChild

        if (tooltipElement) {
            this.popper = createPopper(annotatedElement, tooltipElement, {
                placement: this.getAttribute('data-placement'),
                strategy: this.getAttribute('data-strategy'),
                modifiers: JSON.parse(this.getAttribute('data-modifiers'))
            })

            const requestShow = (e) => {
                tooltipElement.setAttribute('data-show', 'true')
                this.popper.update()
            }
            const requestHide = () => {
                tooltipElement.removeAttribute('data-show')
                this.popper.update()
            }

            const closeClicked = (e) => {
                tooltipElement.removeAttribute('data-show')
                this.popper.update()
            }

            const closeElement = tooltipElement.querySelector('[data-tooltip-close]')

            if (closeElement) closeElement.addEventListener('click', closeClicked)

            annotatedElement.addEventListener('mouseenter', requestShow)
            annotatedElement.addEventListener('focus', requestShow)
            annotatedElement.addEventListener('mouseleave', requestHide)
            annotatedElement.addEventListener('blur', closeClicked)

            this.teardown = () => {
                if (closeElement) closeElement.removeEventListener('click', closeClicked)
                annotatedElement.removeEventListener('mouseenter', requestShow)
                annotatedElement.removeEventListener('focus', requestShow)
                annotatedElement.removeEventListener('mouseleave', requestHide)
                annotatedElement.removeEventListener('blur', closeClicked)
            }
            return
        }

        this.poll = setTimeout(() => {
            this.setup()
            this.poll = null
        }, 100)
    }
}

window.customElements.define('popper-container', PopperContainer)