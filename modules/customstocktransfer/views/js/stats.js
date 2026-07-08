jQuery.migrateMute = true;
document.addEventListener('DOMContentLoaded', () => {
    // Verify existence of required DOM element
    const dashboardContainer = document.getElementById('custom-stock-stats-dashboard');
    
    if (!dashboardContainer) {
        return; // Exit gracefully if we aren't on the stats page
    }

    const doughnutCanvas = document.getElementById('transferStatusDoughnut');
    const trendsCanvas = document.getElementById('transferTrendsChart');

    // =========================================================================
    // 1. Status Breakdown Doughnut Chart
    // =========================================================================
    try {
        if (doughnutCanvas) {
            const rawStatusData = dashboardContainer.getAttribute('data-status-data');
            
            if (rawStatusData) {
                const statusData = JSON.parse(rawStatusData);
                
                const statusConfig = {
                    'pending': { label: 'Pending', color: '#f39c12' },     // Vibrant Orange
                    'approved': { label: 'Approved', color: '#3498db' },   // PrestaShop Blue
                    'completed': { label: 'Completed', color: '#2ecc71' }, // Success Green
                    'declined': { label: 'Declined', color: '#e74c3c' }    // Alert Red
                };

                const labels = [];
                const dataValues = [];
                const backgroundColors = [];

                Object.keys(statusData).forEach(statusKey => {
                    dataValues.push(statusData[statusKey]);
                    
                    if (statusConfig[statusKey]) {
                        labels.push(statusConfig[statusKey].label);
                        backgroundColors.push(statusConfig[statusKey].color);
                    } else {
                        labels.push(statusKey.charAt(0).toUpperCase() + statusKey.slice(1));
                        backgroundColors.push('#95a5a6'); 
                    }
                });

                new Chart(doughnutCanvas, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: dataValues,
                            backgroundColor: backgroundColors,
                            borderWidth: 3,
                            borderColor: '#ffffff',
                            hoverOffset: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutoutPercentage: 75,       // v2
                        cutout: '75%',              // v3+
                        legend: {                   // v2
                            position: 'bottom',
                            labels: { padding: 20, fontColor: '#3f4254', fontFamily: "'Inter', 'Roboto', 'Open Sans', sans-serif" }
                        },
                        plugins: {                  // v3+
                            legend: {
                                position: 'bottom',
                                labels: { padding: 20, color: '#3f4254', font: { family: "'Inter', 'Roboto', 'Open Sans', sans-serif", size: 13 } }
                            },
                            tooltip: { padding: 12, bodyFont: { size: 14 }, cornerRadius: 8 }
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.error('CustomStockStats: Failed to initialize Status Doughnut Chart', e);
    }

    // =========================================================================
    // 2. Transfer Trends Line Chart
    // =========================================================================
    try {
        if (trendsCanvas) {
            const rawTrendsData = dashboardContainer.getAttribute('data-trends-data');
            
            if (rawTrendsData) {
                const trendsData = JSON.parse(rawTrendsData);
                
                // Map the JSON array back into individual label and data arrays
                const trendLabels = trendsData.map(item => item.date);
                const trendValues = trendsData.map(item => item.count);

                new Chart(trendsCanvas, {
                    type: 'line',
                    data: {
                        labels: trendLabels,
                        datasets: [{
                            label: 'Transfers Initiated',
                            data: trendValues,
                            borderColor: '#3498db',
                            backgroundColor: 'rgba(52, 152, 219, 0.12)', // Subtle blue fill
                            borderWidth: 3,
                            pointBackgroundColor: '#ffffff',
                            pointBorderColor: '#3498db',
                            pointBorderWidth: 2,
                            pointRadius: 4,
                            fill: true,
                            tension: 0.4 // Creates smooth, curved lines instead of sharp angles
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { display: false }, // Hide legend for line chart (v2)
                        plugins: { 
                            legend: { display: false }, // v3+
                            tooltip: { padding: 12, bodyFont: { size: 14 }, cornerRadius: 8 }
                        },
                        scales: {
                            // Chart.js v2 configuration
                            yAxes: [{ 
                                ticks: { beginAtZero: true, precision: 0, fontColor: '#7e8299' },
                                gridLines: { color: '#f1f3f7', borderDash: [5, 5] }
                            }],
                            xAxes: [{ 
                                ticks: { fontColor: '#7e8299' },
                                gridLines: { display: false }
                            }],
                            // Chart.js v3+ configuration
                            y: { 
                                beginAtZero: true, 
                                ticks: { precision: 0, color: '#7e8299' },
                                grid: { color: '#f1f3f7', drawBorder: false }
                            },
                            x: { 
                                ticks: { color: '#7e8299' },
                                grid: { display: false, drawBorder: false }
                            }
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.error('CustomStockStats: Failed to initialize Transfer Trends Line Chart', e);
    }
});
