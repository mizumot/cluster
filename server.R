library(shiny)
library(shinyAce)
library(psych)
library(amap)


shinyServer(function(input, output) {



    bs <- reactive({
        if (input$rowname == 1) {
            x <- read.csv(text=input$text, sep="\t")
            x <- x[, -1]
        }else{
            x <- read.csv(text=input$text, sep="\t")
        }
        describe(x)[2:13]
    })
    
    
    
    correl <- reactive({
        
        if (input$rowname == 1) {
            x <- read.csv(text=input$text, sep="\t")
            x <- x[, -1]
        }else{
            x <- read.csv(text=input$text, sep="\t")
        }
        
        type <- switch(input$method,
                       Pearson = "pearson",
                       Spearman = "spearman",
                       Kendall = "kendall")
            
        round(cor(cbind(x), method = type, use = "complete"),3)
    })
    
    
    
    
    
    makecorPlot <- function(){
       
       if (input$rowname == 1) {
           x <- read.csv(text=input$text, sep="\t")
           x <- x[, -1]
       }else{
           x <- read.csv(text=input$text, sep="\t")
       }
       
       type <- switch(input$method,
                      Pearson = "pearson",
                      Spearman = "spearman",
                      Kendall = "kendall")
           
       pairs.panels(x, method = type)
    }
    
    
    output$corPlot <- renderPlot({
        print(makecorPlot())
    })

    
    
    
    
    clusteranalysis <- reactive({
        
        
        if (input$stdz == 0) { # 標準化なし
            
            if (input$rowname == 1) {
                x <- read.csv(text=input$text, sep="\t")
                x <- x[, -1]
            } else {
                x <- read.csv(text=input$text, sep="\t")
            }
            
                if (input$type == "case") { # ケースクラスターと変数クラスターの違い
                    z <- as.matrix(x)
                    z <- data.frame(z)
                } else {
                    z <- as.matrix(x)
                    z <- data.frame(z)
                    z <- t(z)
                }
            
                if (input$distancce == "squared.euclidean") { # 平方ユークリッド距離
                    
                    linkage <- switch(input$linkage, ward = "ward", single = "single", complete = "complete", average = "average",
                        mcquitty = "mcquitty", median = "median", centroid = "centroid")
                    
                    z.d <- dist(z)^2
                    hc <- hclust(z.d, method=linkage)
                
                } else { # 平方ユークリッド距離「以外」
                    
                    linkage <- switch(input$linkage, ward = "ward", single = "single", complete = "complete", average = "average",
                         mcquitty = "mcquitty", median = "median", centroid = "centroid")
                    
                    distanceM <- switch(input$distancce, euclidean = "euclidean", maximum = "maximum",
                         manhattan = "manhattan", canberra = "canberra", binary = "binary", pearson ="pearson",
                         abspearson = "abspearson", correlation = "correlation", abscorrelation = "abscorrelation",
                         spearman = "spearman", kendall = "kendall")
                    
                    hc <- hcluster(z, method = distanceM, link = linkage)

                }
        
        } else { # 標準化あり
            
            if (input$rowname == 1) {
                x <- read.csv(text=input$text, sep="\t")
                x <- x[, -1]
            }else{
                x <- read.csv(text=input$text, sep="\t")
            }
            
                if (input$type == "case") { # ケースクラスターと変数クラスターの違い
                    x <- as.matrix(x)
                    z <- scale(x) # ここで標準化
                    z <- data.frame(z)
                } else {
                    x <- as.matrix(x)
                    z <- scale(x) # ここで標準化
                    z <- data.frame(z)
                    z <- t(z)
                }
            
            
                if (input$distancce == "squared.euclidean") { # 平方ユークリッド距離
                   
                   linkage <- switch(input$linkage, ward = "ward", single = "single", complete = "complete", average = "average",
                   mcquitty = "mcquitty", median = "median", centroid = "centroid")
                   
                   z.d <- dist(z)^2
                   hc <- hclust(z.d, method=linkage)
                   
                } else { # 平方ユークリッド距離「以外」
                   
                   linkage <- switch(input$linkage, ward = "ward", single = "single", complete = "complete", average = "average", mcquitty = "mcquitty", median = "median", centroid = "centroid")
                   
                   distanceM <- switch(input$distancce, euclidean = "euclidean", maximum = "maximum", manhattan = "manhattan", canberra = "canberra", binary = "binary", pearson ="pearson",
                        abspearson = "abspearson", correlation = "correlation", abscorrelation = "abscorrelation",
                        spearman = "spearman", kendall = "kendall")
                   
                   hc <- hcluster(z, method = distanceM, link = linkage)
                }
        }
        
        list(hc = hc) #他で使用するため
    })





    makeclusterPlot <- function(){
        
        res <- clusteranalysis()$hc
        plot(res, las = 1, hang = -1, xlab="", sub="")
    
    }
    
    output$clusterPlot <- renderPlot({
        print(makeclusterPlot()) # 上の function を参照する指定
    })


    
    
    
    specifiedCluster <- reactive({
        
        res <- clusteranalysis()$hc
        
        nclust <- input$numspec # クラスター数
        cluster <- cutree(res, k=nclust)
        cluster <- factor(cluster)
        
        
        if (input$type == "case") { # ケースクラスターの場合
            if (input$rowname == 1) {
                x <- read.csv(text=input$text, sep="\t")
                x <- x[, -1]
            } else {
                x <- read.csv(text=input$text, sep="\t")
            }
                x <- as.matrix(x)
                x <- data.frame(x)
                # z <- scale(x) # ここで標準化
                # z <- data.frame(z)
        
            xx <- cbind(x, cluster)        # 素点のデータフレーム
            # zz <- cbind(z, cluster)
        
            describeBy(xx[1:ncol(xx)-1], group = cluster)
        
        } else { # 変数クラスターの場合は何も表示しない
            cat("\n")
        }
    
    })





    makespecPlot <- function(){
    
        res <- clusteranalysis()$hc
        plot(res, las = 1, hang = -1, xlab="", sub="")
        
        nclust <- input$numspec # クラスター数
        rect.hclust(res, k=nclust, border="red") # rect.hclustでクラスターごとにいろをつける
    }
    
    output$specPlot <- renderPlot({
        
        print(makespecPlot()) # 上の function を参照する指定

    })


    
    
    
    makeProfilePlot <- function(){
        
        res <- clusteranalysis()$hc
        
        nclust <- input$numspec # クラスター数
        cluster <- cutree(res, k=nclust)
        cluster <- factor(cluster)
        
        
        if (input$type == "case") { # ケースクラスターの場合
            if (input$rowname == 1) {
                x <- read.csv(text=input$text, sep="\t")
                x <- x[, -1]
            } else {
                x <- read.csv(text=input$text, sep="\t")
            }
            x <- as.matrix(x)
            x <- data.frame(x)
            z <- scale(x) # ここで標準化
            z <- data.frame(z)
            
            x <- cbind(x, cluster)  # 素点のデータフレーム
            z <- cbind(z, cluster)  # 標準化得点のデータフレーム
            
            means <- aggregate(z[, 1:ncol(x)-1], by=list(z$cluster), FUN=mean)
            means <- means[,-1]
            
            minmax <- unlist(means)
            minimum <- min(minmax, na.rm = TRUE)
            maximum <- max(minmax, na.rm = TRUE)
            
            lbls <- c()
            for (i in 1:nclust) {
                lbls[i] <- paste("Cluster",i)
            }
            
            par(xaxt="n")
            
            lim <- max(abs(c(minimum, maximum)))+0.5
            
            plot(c(0,0), xlim=c(1, ncol(x)-1), ylim=c(-lim,lim), type="n", xlab="Variables", ylab="z-scores")
            
            par(xaxt="s")  #横軸に座標を再度書く指定
            axis(1, c(1:(ncol(x)-1)), colnames(x)[1:(ncol(x)-1)])
            
            legend("topright", legend = lbls, lty = c(1:nclust), pch = c(1:nclust), col=c(1:nclust), cex=.8, angle = 45)
            
            abline(h=0, lwd=0.2, lty=1)
            
            means <- t(means)
            
            for (i in 1:nclust) {
                points(means[,i], pch=i, col=i)
                lines(means[,i], pch=i, col=i, lty=i)
            }
        }
    }
    
    output$profilePlot <- renderPlot({
        print(makeProfilePlot()) # 上の function を参照する指定
    })
    
    
    
    
    
    info <- reactive({
        info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")# バージョン情報
        info2 <- paste("It was executed on ", date(), ".", sep = "")# 実行日時
        cat(sprintf(info1), "\n")
        cat(sprintf(info2), "\n")
    })
    
    output$info.out <- renderPrint({
        info()
    })





    output$textarea.out <- renderPrint({
        bs()
    })

    output$correl.out <- renderPrint({
        correl()
    })
    
    output$clusteranalysis.out <- renderPrint({
        clusteranalysis()
    })
    
    output$specifiedCluster.out <- renderPrint({
        specifiedCluster()
    })
    
    output$downloadCorPlot <- downloadHandler(
    filename = function() {
        paste('Corplot-', Sys.Date(), '.pdf', sep='')
    },
    content = function(FILE=NULL) {
        pdf(file=FILE)
		print(makecorPlot())
		dev.off()
	}
    )
    
    output$downloadClusterPlot <- downloadHandler(
    filename = function() {
        paste('ClusterPlot-', Sys.Date(), '.pdf', sep='')
    },
    content = function(FILE=NULL) {
        pdf(file=FILE)
		print(makeclusterPlot())
		dev.off()
	}
    )
    
    output$downloadSpecClusterPlot <- downloadHandler(
    filename = function() {
        paste('SpecClusterPlot-', Sys.Date(), '.pdf', sep='')
    },
    content = function(FILE=NULL) {
        pdf(file=FILE)
		print(makespecPlot())
		dev.off()
	}
    )

    output$downloadProfilePlot <- downloadHandler(
    filename = function() {
        paste('ProfilePlot-', Sys.Date(), '.pdf', sep='')
    },
    content = function(FILE=NULL) {
        pdf(file=FILE)
        print(makeProfilePlot())
        dev.off()
    }
    )






})
