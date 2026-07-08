jQuery.migrateMute = true;
document.addEventListener('DOMContentLoaded', () => {
    // Verify existence of required DOM element
    const dashboardContainer = document.getElementById('custom-stock-stats-dashboard');
    
    if (!dashboardContainer) {
        return; // Exit gracefully if we aren't on the stats page
    }

    const doughnutCanvas = document.getElementById('transferStatusDoughnut');
    const trendsCanvas = document.getElementById('transferTrendsChart');
    const topProductsCanvas = document.getElementById('topProductsChart');
    const storeActivityCanvas = document.getElementById('storeActivityChart');

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

    // =========================================================================
    // 3. Top Products Horizontal Bar Chart
    // =========================================================================
    try {
        if (topProductsCanvas) {
            const rawTopProductsData = dashboardContainer.getAttribute('data-top-products');
            
            if (rawTopProductsData) {
                const topProductsData = JSON.parse(rawTopProductsData);
                
                const productLabels = topProductsData.map(item => item.name);
                const productValues = topProductsData.map(item => item.total_qty);

                new Chart(topProductsCanvas, {
                    type: 'bar', // Note: Chart.js v3+ uses 'bar' with indexAxis: 'y' for horizontal bars, v2 uses 'horizontalBar'
                    data: {
                        labels: productLabels,
                        datasets: [{
                            label: 'Quantity Transferred',
                            data: productValues,
                            backgroundColor: 'rgba(16, 185, 129, 0.8)', // Emerald Green
                            borderRadius: 6, // v3+ only, gives rounded corners to bars
                            borderWidth: 0,
                            barThickness: 24
                        }]
                    },
                    options: {
                        indexAxis: 'y', // Configures horizontal bar for Chart.js v3+
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { display: false },
                        plugins: {
                            legend: { display: false },
                            tooltip: { padding: 14, bodyFont: { size: 14, family: "'Inter', sans-serif" }, cornerRadius: 10 }
                        },
                        scales: {
                            yAxes: [{ 
                                ticks: { fontColor: '#64748b' },
                                gridLines: { display: false, drawBorder: false }
                            }],
                            xAxes: [{ 
                                ticks: { beginAtZero: true, display: false },
                                gridLines: { display: false, drawBorder: false }
                            }],
                            y: { 
                                ticks: { color: '#64748b' },
                                grid: { display: false, drawBorder: false }
                            },
                            x: { 
                                beginAtZero: true, 
                                ticks: { display: false },
                                grid: { display: false, drawBorder: false }
                            }
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.error('CustomStockStats: Failed to initialize Top Products Chart', e);
    }

    // =========================================================================
    // 4. Store Activity Clustered Bar Chart
    // =========================================================================
    try {
        if (storeActivityCanvas) {
            const rawStoreActivityData = dashboardContainer.getAttribute('data-store-activity');
            
            if (rawStoreActivityData) {
                const storeActivityData = JSON.parse(rawStoreActivityData);
                
                const storeLabels = storeActivityData.map(item => item.name);
                const sentValues = storeActivityData.map(item => item.sent);
                const receivedValues = storeActivityData.map(item => item.received);

                new Chart(storeActivityCanvas, {
                    type: 'bar',
                    data: {
                        labels: storeLabels,
                        datasets: [
                            {
                                label: 'Sent',
                                data: sentValues,
                                backgroundColor: 'rgba(59, 130, 246, 0.9)', // Blue
                                borderRadius: 4,
                                borderWidth: 0
                            },
                            {
                                label: 'Received',
                                data: receivedValues,
                                backgroundColor: 'rgba(245, 158, 11, 0.9)', // Amber
                                borderRadius: 4,
                                borderWidth: 0
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { 
                            position: 'top', 
                            labels: { padding: 15, fontColor: '#64748b', fontFamily: "'Inter', sans-serif" }
                        },
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: { padding: 15, color: '#64748b', font: { family: "'Inter', sans-serif", size: 13, weight: 500 } }
                            },
                            tooltip: { padding: 14, bodyFont: { size: 14, family: "'Inter', sans-serif" }, cornerRadius: 10 }
                        },
                        scales: {
                            yAxes: [{ 
                                ticks: { beginAtZero: true, precision: 0, fontColor: '#94a3b8' },
                                gridLines: { color: '#f1f3f7', borderDash: [5, 5] }
                            }],
                            xAxes: [{ 
                                ticks: { fontColor: '#94a3b8' },
                                gridLines: { display: false }
                            }],
                            y: { 
                                beginAtZero: true, 
                                ticks: { precision: 0, color: '#94a3b8' },
                                grid: { color: '#f1f3f7', drawBorder: false }
                            },
                            x: { 
                                ticks: { color: '#94a3b8' },
                                grid: { display: false, drawBorder: false }
                            }
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.error('CustomStockStats: Failed to initialize Store Activity Chart', e);
    }
});
