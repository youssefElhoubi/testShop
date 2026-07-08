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
    // 1. Status Breakdown Doughnut Chart (SaaS Aesthetic)
    // =========================================================================
    try {
        if (doughnutCanvas) {
            const rawStatusData = dashboardContainer.getAttribute('data-status-data');
            
            if (rawStatusData) {
                const statusData = JSON.parse(rawStatusData);
                
                // Modern SaaS Palette
                const statusConfig = {
                    'pending': { label: 'Pending', color: '#f59e0b' },     // Amber
                    'approved': { label: 'Approved', color: '#3b82f6' },   // Blue
                    'completed': { label: 'Completed', color: '#10b981' }, // Emerald Green
                    'declined': { label: 'Declined', color: '#ef4444' }    // Soft Red
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
                        backgroundColors.push('#cbd5e1'); // Soft slate fallback
                    }
                });

                new Chart(doughnutCanvas, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: dataValues,
                            backgroundColor: backgroundColors,
                            borderWidth: 0, // Cut out borders for a seamless modern look
                            hoverOffset: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutoutPercentage: 75,       // v2
                        cutout: '75%',              // v3+
                        legend: {                   // v2
                            position: 'bottom',
                            labels: { padding: 25, fontColor: '#64748b', fontFamily: "'Inter', sans-serif" }
                        },
                        plugins: {                  // v3+
                            legend: {
                                position: 'bottom',
                                labels: { padding: 25, color: '#64748b', font: { family: "'Inter', sans-serif", size: 13, weight: 500 } }
                            },
                            tooltip: { padding: 14, bodyFont: { size: 14, family: "'Inter', sans-serif" }, cornerRadius: 10 }
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.error('CustomStockStats: Failed to initialize Status Doughnut Chart', e);
    }

    // =========================================================================
    // 2. Transfer Trends Line Chart (SaaS Aesthetic)
    // =========================================================================
    try {
        if (trendsCanvas) {
            const rawTrendsData = dashboardContainer.getAttribute('data-trends-data');
            
            if (rawTrendsData) {
                const trendsData = JSON.parse(rawTrendsData);
                
                const trendLabels = trendsData.map(item => item.date);
                const trendValues = trendsData.map(item => item.count);

                // Create a soft gradient for the fill under the line
                const ctx = trendsCanvas.getContext('2d');
                let gradient = 'rgba(59, 130, 246, 0.1)'; // Fallback
                if (ctx) {
                    gradient = ctx.createLinearGradient(0, 0, 0, 400);
                    gradient.addColorStop(0, 'rgba(59, 130, 246, 0.25)'); // Stronger blue at top
                    gradient.addColorStop(1, 'rgba(59, 130, 246, 0.0)');  // Fade to transparent at bottom
                }

                new Chart(trendsCanvas, {
                    type: 'line',
                    data: {
                        labels: trendLabels,
                        datasets: [{
                            label: 'Transfers Initiated',
                            data: trendValues,
                            borderColor: '#3b82f6', // SaaS Blue
                            backgroundColor: gradient,
                            borderWidth: 3,
                            pointBackgroundColor: '#ffffff',
                            pointBorderColor: '#3b82f6',
                            pointBorderWidth: 2,
                            pointRadius: 5,
                            pointHoverRadius: 7,
                            fill: true,
                            tension: 0.4 // Smooth bezier curves
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { display: false }, // v2
                        plugins: { 
                            legend: { display: false }, // v3+
                            tooltip: { padding: 14, bodyFont: { size: 14, family: "'Inter', sans-serif" }, cornerRadius: 10 }
                        },
                        scales: {
                            // Chart.js v2 configuration
                            yAxes: [{ 
                                ticks: { beginAtZero: true, precision: 0, fontColor: '#94a3b8' },
                                gridLines: { display: false } // Hide grid lines
                            }],
                            xAxes: [{ 
                                ticks: { fontColor: '#94a3b8' },
                                gridLines: { display: false } // Hide grid lines
                            }],
                            // Chart.js v3+ configuration
                            y: { 
                                beginAtZero: true, 
                                ticks: { precision: 0, color: '#94a3b8' },
                                grid: { display: false, drawBorder: false } // Hide grid lines
                            },
                            x: { 
                                ticks: { color: '#94a3b8' },
                                grid: { display: false, drawBorder: false } // Hide grid lines
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
