/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{vue,js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                primary: '#5371C4',
                secondary: '#FCFCFC',
                accent: '#CEEAC7',
                'onkos-dark-blue': '#223675',
                'onkos-medium-blue': '#5371C4',
                'onkos-light-blue': '#C3E1ED',
                'onkos-light-green': '#CEEAC7',
                'onkos-grey': '#D0D0D0',
                'onkos-white': '#FCFCFC',
            },
            fontFamily: {
                sans: ['Inter', 'sans-serif'],
            }
        },
    },
    plugins: [],
}
