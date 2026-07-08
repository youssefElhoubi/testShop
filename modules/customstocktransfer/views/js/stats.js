document.addEventListener('DOMContentLoaded', () => {
    // 1. Verify existence of required DOM elements
    const dashboardContainer = document.getElementById('custom-stock-stats-dashboard');
    const doughnutCanvas = document.getElementById('transferStatusDoughnut');

    // Exit gracefully if we aren't on the stats page
    if (!dashboardContainer || !doughnutCanvas) {
        return;
    }

    // 2. Extract and safely parse the JSON data
    const rawData = dashboardContainer.getAttribute('data-status-data');
    if (!rawData) {
        console.warn('CustomStockStats: No status data found in data attribute.');
        return;
    }

    let statusData;
    try {
        statusData = JSON.parse(rawData);
    } catch (error) {
        console.error('CustomStockStats: Failed to parse status data JSON.', error);
        return;
    }

    // 3. Prepare labels, values, and premium colors for the chart
    // Mapping keys to capitalized labels and PrestaShop-friendly modern colors
    const statusConfig = {
        'pending': { label: 'Pending', color: '#f39c12' },     // Vibrant Orange
        'approved': { label: 'Approved', color: '#3498db' },   // PrestaShop Blue
        'completed': { label: 'Completed', color: '#2ecc71' }, // Success Green
        'declined': { label: 'Declined', color: '#e74c3c' }    // Alert Red
    };

    const labels = [];
    const dataValues = [];
    const backgroundColors = [];

    // Loop through the parsed backend data and build the Chart.js arrays
    Object.keys(statusData).forEach(statusKey => {
        dataValues.push(statusData[statusKey]);
        
        if (statusConfig[statusKey]) {
            labels.push(statusConfig[statusKey].label);
            backgroundColors.push(statusConfig[statusKey].color);
        } else {
            // Safe fallback for unexpected statuses
            labels.push(statusKey.charAt(0).toUpperCase() + statusKey.slice(1));
            backgroundColors.push('#95a5a6'); // Neutral Grey
        }
    });

    // 4. Instantiate the Doughnut Chart
    // Using configuration options compatible with both older (v2) and newer (v3/v4) Chart.js
    new Chart(doughnutCanvas, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: dataValues,
                backgroundColor: backgroundColors,
                borderWidth: 3,
                borderColor: '#ffffff', // Clean white border separating segments
                hoverOffset: 6 // Slight pop effect on hover (v3/v4 feature)
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // Allows the canvas to fill our CSS flex container
            cutoutPercentage: 75,       // Thin, elegant ring (Chart.js v2)
            cutout: '75%',              // Thin, elegant ring (Chart.js v3+)
            legend: {                   // Legend config for Chart.js v2
                position: 'bottom',
                labels: {
                    padding: 20,
                    fontColor: '#3f4254',
                    fontFamily: "'Inter', 'Roboto', 'Open Sans', sans-serif"
                }
            },
            plugins: {                  // Legend config for Chart.js v3+
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        color: '#3f4254',
                        font: {
                            family: "'Inter', 'Roboto', 'Open Sans', sans-serif",
                            size: 13
                        }
                    }
                },
                tooltip: {
                    padding: 12,
                    bodyFont: {
                        size: 14
                    },
                    cornerRadius: 8
                }
            }
        }
    });
});
